//
//  Sender.swift
//  cartrol
//
//  Created by William Snook on 5/9/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import SwiftUI
import Darwin.C

let useDatagramProtocol = true

// Current expected connection state, determined by status of session with target device
enum ConnectionState: String {          // State of communication channel to device
    case connected = "Connected"            // Ready for commands, expecting responses
    case connecting = "Connecting"          // Actively looking for and waiting for connection acceptance
    case disconnecting = "Disconnecting"    // Actively disconnecting from device
    case disconnected = "Disconnected"      // Currently not accepting commands, not expecting responses
    func buttonName() -> String {
        switch self {
        case .connected: return "Disconnect"
        case .connecting: return "Connecting..."
        case .disconnecting: return "Disconnecting..."
        case .disconnected: return "Connect"
        }
    }
}
let initialState: ConnectionState = .disconnected    // For testing buttons, use connected, else use disconnected

public class Sender: ObservableObject {
    @Published var connectionState: ConnectionState = initialState
    @Published var responseString: String = "Ready..."

    var socketfd: Int32 = 0
    var deadTime = Timer()

    public init() {}

    deinit {
        doBreakConnection()
    }

    // Called from connect button in ConnectView to connect or disconnect to selected robot device
    func requestConnectionStateChange(_ connectionRequest: ConnectionRequest, _ hostName: String) {
        print("Sender, received \(connectionRequest.rawValue) in connection state \(connectionState.rawValue)")
        switch (connectionRequest, connectionState) {
        case (.connect, .connected):
            startResponse("WARNING - already connected")
        case (.connect, .disconnected):
            connectionState = .connecting
            startResponse("OK - connecting")
            startConnection(hostName)
        case (.disconnect, .connected):
            connectionState = .disconnecting
//            startResponse("OK - disconnecting")       // Leave for now for diagnostic purposes
            doBreakConnection()
            startResponse("OK - disconnected")
        default:
            startResponse("Warning - invalid request received: \(connectionRequest.rawValue) in connection state \(connectionState.rawValue)")
        }
    }

    func startResponse(_ message: String) {
        responseString = message
    }

    private func updateResponse(_ message: String) {    // With message received froom device

//        print(">> \(message)")
        switch message.first {
        case "R":
            let params = message.split(separator: " ")
            guard params.count == 3 else { return }
//            pwmTextField.text = String(params[1])
//            pinTextField.text = String(params[2])
//            pwmIsValid = true
//            pinIsValid = true
        case "S":
            print(">> Got speed index file from device")
            speedIndex.setup(message)
        case "T":
            responseString += "\n----    Got Camera data, deprecated    ----\n" + message
        default:
            responseString += "\n" + message
        }
    }

    // Here we have an array of bytes corresponding to the depth data from the tof camera
    // (with the two byte header, C0). For just one center line for now, 240 bytes.
    private func sendData(_ message: [CChar]) {


        responseString = "\nGot tof camera data\n"
    }

	public func doBreakConnection() {
        if connectionState != .disconnected {
            sendPi( "#" )               // Sign off device
            usleep( 1000000 )
            deadTime.invalidate()       // Stop sending keep-alive
			if socketfd != 0 {
				close( socketfd )
				socketfd = 0
			}
            connectionState = .disconnected
		}
	}
	
	public func doMakeConnection( to address: String, at port: UInt16 ) -> Bool {
        updateResponse(" Connect to device \(address) at port \(port) using \(useDatagramProtocol ? "UDP" : "TCP")")
        if socketfd != 0 {
            close( socketfd )
            socketfd = 0
        }
        if useDatagramProtocol {
            socketfd = socket( AF_INET, SOCK_DGRAM, 0 )         // ipv4, udp
        } else {
            socketfd = socket( AF_INET, SOCK_STREAM, 0 )        // ipv4, tcp
        }

		guard let targetAddr = doLookup( name: address ) else {
            updateResponse(" Lookup failed for \(address)")
			return false
		}

        updateResponse(" Found target address: \(targetAddr), connecting...")
        let result = doConnect( targetAddr, port: port )
        guard result >= 0 else {
            updateResponse(" Connect failed for \(targetAddr), port \(port), error: \(result)")
            return false
        }
        updateResponse(" Connected on socket \(socketfd) on our port \(port) to host address \(address): (\(targetAddr))\n")

        readThread()    // Loop waiting for response, exits on read error
        
		return true
	}
	
	func doLookup( name: String ) -> String? {
		var hints = addrinfo(
			ai_flags: AI_PASSIVE,       // Assign the address of my local host to the socket structures
			ai_family: AF_INET,      	// IPv4
            ai_socktype: SOCK_STREAM,   // UDP -- SOCK_STREAM for TCP - Either seem to work here
			ai_protocol: 0, ai_addrlen: 0, ai_canonname: nil, ai_addr: nil, ai_next: nil )
		var servinfo: UnsafeMutablePointer<addrinfo>? = nil		// For the result from the getaddrinfo
		let status = getaddrinfo( name + ".local", "5555", &hints, &servinfo)
		guard status == 0 else {
//			let stat = strerror( errno )
            updateResponse(" Address lookup failed for \(name), status: \(status)") // , error: \(String(describing: stat))")
			return nil
		}
		
		var target: String?
		var info = servinfo
		while info != nil {					// Check for addresses - typically there is only one ipv4 address
			var ipAddressString = [CChar]( repeating: 0, count: Int(INET_ADDRSTRLEN) )
			let sockAddrIn = info!.pointee.ai_addr.withMemoryRebound( to: sockaddr_in.self, capacity: 1 ) { $0 }
			var ipaddr_raw = sockAddrIn.pointee.sin_addr.s_addr
			inet_ntop( info!.pointee.ai_family, &ipaddr_raw, &ipAddressString, socklen_t(INET_ADDRSTRLEN))
			let ipaddrstr = String( cString: &ipAddressString )
			if strlen( ipaddrstr ) < 16 {	// Valid IPV4 address string
				target = ipaddrstr
				break						// Get first valid IPV4 address
			}
            updateResponse(" Got target address: \(String(describing: target))")
			info = info!.pointee.ai_next
		}
		freeaddrinfo( servinfo )
		return target
	}
	
	
	func doConnect( _ addr: String, port: UInt16 ) -> Int32 {
		var serv_addr_in = sockaddr_in( sin_len: __uint8_t(MemoryLayout< sockaddr_in >.size), sin_family: sa_family_t(AF_INET), sin_port: port.bigEndian, sin_addr: in_addr( s_addr: inet_addr(addr) ), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0) )
		let serv_addr_len = socklen_t(MemoryLayout.size( ofValue: serv_addr_in ))
		let connectResult = withUnsafeMutablePointer( to: &serv_addr_in ) {
			$0.withMemoryRebound( to: sockaddr.self, capacity: 1 ) {
				connect( socketfd, $0, serv_addr_len )
			}
		}
		if connectResult < 0 {
			let stat = String( describing: strerror( errno ) )
            updateResponse(" ERROR connecting \(connectResult), errno: \(errno), \(stat)")
			return connectResult
		}
        return connectResult
    }
    
    func readThread() {         // Start read thread
		DispatchQueue.global(qos: .userInitiated).async { [weak self] () -> Void in
			while self?.socketfd != 0 {
				var readBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
				var rcvLen = 0
                if useDatagramProtocol {
                    rcvLen = recv(self!.socketfd, &readBuffer, 1024, 0)
                } else {
                    rcvLen = read(self!.socketfd, &readBuffer, 1024 )
                }
				if rcvLen <= 0 {
                    self?.updateResponse(" Connection lost while receiving, \(rcvLen)")
                    break
				} else {
                    if readBuffer.first == 0x43 {
                        self?.sendData(readBuffer)
                    } else {
                        let str = String( cString: readBuffer, encoding: .utf8 ) ?? "bad data"
                        self?.updateResponse(" " + str)
//                        self?.updateResponse(" Read \(rcvLen) bytes from socket \(self!.socketfd):\n-- \(str) --\n")
                    }
				}
			}
            // If we get here, read has received an error which usually means a comm failure on the robot
//            DispatchQueue.main.async {
////            self.deadTime.invalidate()
////            self.deadTime = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerStart), userInfo: nil, repeats: false )
//                self?.sendPi( "@" ) // Get status
//            }
		}
	}
	
    @discardableResult public func sendPi( _ message: String ) -> Bool {
		
        guard connectionState == .connected else {
            updateResponse(" Socket not connected while sending \(message)")
            return false
        }

        if (message.count > 2) {
            updateResponse(" sendPi is sending the message \(message)")
        }
        deadTime.invalidate()
        deadTime = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false )
        let command = message + "\0";
		var writeBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
		strcpy( &writeBuffer, command )
		let len = strlen( command )
        var sndLen = 0
        if useDatagramProtocol {
            sndLen = send( socketfd, &writeBuffer, Int(len), 0 )
        } else {
            sndLen = write( socketfd, &writeBuffer, Int(len) )
        }
		if ( sndLen < 0 ) {
//            self.updateResponse("   Connection lost while sending, \(sndLen)")
            return false
		}
		return true
	}

    @objc func timerAction() {
        sendPi( "?" )   // Keep-alive
//        print( "?", terminator: "")
    }

    @objc func timerStart() {
        sendPi( "@" )   // Trigger start
        print( "@", terminator: "")
    }

    func startConnection(_ hostName: String) {
        DispatchQueue.global( qos: .userInitiated ).async {
            let connectResult = self.doMakeConnection( to: hostName, at: 5555 )
            if connectResult {
                self.connectionState = .connected
                self.updateResponse(" Connected to host \(hostName)")
            } else {
                self.connectionState = .disconnected
                self.updateResponse(" Failed to connect to host \(hostName)")
            }
        }
    }
}
