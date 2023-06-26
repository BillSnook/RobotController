//
//  ConnectView.swift
//  RobotController
//
//  Created by Bill Snook on 6/25/23.
//

import SwiftUI

var isConnected = false     // WFS true for testing UI w/o connection
var isConnecting = false    // Enables cancelling

struct ConnectView: View {
    
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

        func name() -> String {
            switch self {
            case .hughie:
                return "Develop60"
            case .dewie:
                return "Develop61"
            case .louie:
                return "Develop62"
            default:
                return id
            }
        }
    }

    @ObservedObject var commObject: Sender

    @State private var selectedDevice: Devices = .hughie
    
    let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
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
                Text(commObject.connectionState == .connecting ? "Connecting..." : commObject.connectionRequest.rawValue)
            }
            .buttonStyle(.bordered)
            .background(commObject.connectionState == .connecting ? .clear : lightGray)
            .foregroundColor(commObject.connectionState == .connecting ? .gray : .black)
            .cornerRadius(10.0)
            Spacer()
        }
        .padding(EdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 0.0))
    }
    
    func connectionButtonAction() {
        print("\nConnectView NOTE - Requested \(commObject.connectionRequest.rawValue) in connection state \(commObject.connectionState.rawValue)")
        if commObject.connectionRequest == .connect {
            commObject.requestConnectionStateChange(.connect, selectedDevice.name())
        } else {
            commObject.requestConnectionStateChange(.disconnect, selectedDevice.name())
            commObject.connectionRequest = .connect

        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Form {
                Section() {
                    ConnectView(commObject: targetPort)
                }
           }
       }
    }
}
