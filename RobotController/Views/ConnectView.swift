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
        case donald
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

    // This is the Sender object and here we get updates whenever any of it's @Published object changes
    @ObservedObject var commObject = targetPort

    @State private var selectedDevice: Devices = .donald

    var connectionRequest: ConnectionRequest = .connect

    var body: some View {
        HStack {
            if commObject.connectionState == .disconnected {
                Picker("Robot", selection: $selectedDevice) {
                    ForEach(Devices.allCases) { devices in
                        Text(devices.rawValue.capitalized).tag(devices)
                    }
                }
                .frame(width: 140.0, height: 0.0)
                .pickerStyle(MenuPickerStyle())
                .position(CGPoint(x: 70.0, y: 10.0))
                .padding(EdgeInsets(top: 10.0, leading: 0.0, bottom: 0.0, trailing: 0.0))

                Spacer()
                    .background(.orange)
                Button(action: {
                    connectionButtonAction()
                }) {
                    Text(commObject.connectionState.buttonName())
                }
                .buttonStyle(.bordered)
                .background(lightGray)
                .foregroundColor(.black)
                .cornerRadius(10.0)
                Spacer()
                    .background(.orange)
            } else {
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

        }
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
