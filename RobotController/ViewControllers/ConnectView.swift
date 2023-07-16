//
//  ConnectView.swift
//  RobotController
//
//  Created by Bill Snook on 6/25/23.
//

import SwiftUI

// Button function/name
enum ConnectionRequest: String {
    case connect = "Connect"
    case disconnect = "Disconnect"
}

struct ConnectView: View {
    
    // Known devices using their .local network names
    enum Devices: String, CaseIterable, Identifiable {
        case camera01
        case hughie
        case dewie
        case louie
        case develop00
        case develop01
        case develop40
        case develop50
        case devx
        
        var id: String { self.rawValue.capitalized }
    }

    let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)

    // This is the Sender object and here we get updates when ever any @Published object changes
    @ObservedObject var commObject = targetPort

    @State private var selectedDevice: Devices = .louie

    var connectionRequest: ConnectionRequest = .connect

    var body: some View {
        HStack {
            if commObject.connectionState == .disconnected {
                Picker("Robot", selection: $selectedDevice) {
                    ForEach(Devices.allCases) { devices in
                        Text(devices.rawValue.capitalized).tag(devices)
                    }
                }
                .frame(width: 160.0, height: 0.0)
                .pickerStyle(MenuPickerStyle())
                .position(CGPoint(x: 50.0, y: 10.0))
                .padding(20.0)
            }

            Spacer()
            Button(action: {
                connectionButtonAction()
            }) {
                Text(commObject.connectionState.buttonName())
            }
            .buttonStyle(.bordered)
            .background(commObject.connectionState == .connecting ? .clear : lightGray)
            .foregroundColor(commObject.connectionState == .connecting ? .gray : .black)
            .cornerRadius(10.0)
            Spacer()
        }
//        .padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 0.0))
    }
    
    func connectionButtonAction() {
        print("\nConnectView, requested \(connectionRequest.rawValue) in connection state \(commObject.connectionState.rawValue)")
        if commObject.connectionState == .disconnected {
            print("  Requesting connect")
            commObject.requestConnectionStateChange(.connect, selectedDevice.id)
        } else {
            print("  Requesting disconnect")
            commObject.requestConnectionStateChange(.disconnect, selectedDevice.id)
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Form {
                Section() {
                    ConnectView()
                }
           }
       }
    }
}
