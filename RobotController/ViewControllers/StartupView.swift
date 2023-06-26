//
//  StartupView.swift
//  RobotController
//
//  Created by Bill Snook on 6/23/23.
//

import SwiftUI

struct StartupView: View {
    
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

    @State private var fullText: String = "Responses show up here."

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section() {
                        ConnectView(commObject: commObject)
                        if commObject.connectionState == .connected {
                            HStack {
                                Button("Send") {
                                    print("Send Sent")
                                }
                                .buttonStyle(.bordered)
                                TextField("Type command here", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                                    .textFieldStyle(.roundedBorder)
                            }
                            HStack {
                                Button("Calibrate") {
                                    print("Send Calibrate")
                                    fullText += "\nSent Calibrate"
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Control") {
                                    fullText += "\nSent Control"
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Direct") {
                                    fullText += "\nSent Direct"
                                }
                                .buttonStyle(.bordered)
                            }
                            HStack {
                                Button("Status") {
                                    fullText = "Sent Status Request"
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Range") {
                                    fullText = "Sent Range Request"
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Clear") {
                                    fullText = "Sent Clear Request"
                                }
                                .buttonStyle(.bordered)
                            }
                            HStack {
                                Button("Ping") {
                                    print("Send Ping")
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Center") {
                                    print("Send Center")
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Stop") {
                                    print("Send Stop")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
                    Section() {
                        TextEditor(text: $commObject.responseString)
                    }
                }
            }
            .navigationBarTitle("Robot Commander", displayMode: .inline)
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView(commObject: targetPort)
    }
}
