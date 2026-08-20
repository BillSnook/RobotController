//
//  StartupView.swift
//  BotComm
//
//  Created by Bill Snook on 6/23/23.
//

import SwiftUI

let targetPort = Sender()
let speedIndex = Speed.shared


struct StartupView: View {

    @StateObject var commObject = targetPort

    @State private var path: [String] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .center) {
                Form {
                    Section() {
                        ConnectView()
                    }
                    if commObject.connectionState == .connected {
                        Section() {
                            SendCommandView()
                            HStack {
                                Button("Calibrate") {
                                    print("Calibrate nav link")
                                    path.append("CalibrateView")
                                    commObject.sendPi("D")          // Request device speedIndex data
                                }
                                .buttonStyle(.bordered)

                                Spacer()
                                Button("Control") {
                                    print("Control nav link")
                                    path.append("DriveView")
                                }
                                .buttonStyle(.bordered)

                                Spacer()
                                Button("Direct") {
                                    print("Direct control  - not finished")
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))

                            HStack {
                                Button("Status") {
                                    print("Send Status Request")
                                    commObject.sendPi( "@" )
                                    commObject.startResponse("\nSent Status Request\n")
                                }
                                .buttonStyle(.bordered)

                                Spacer()
                                Button("Range") {
                                }
                                .buttonStyle(.bordered)

                                Spacer()
                                Button("Clear") {
                                    commObject.startResponse("")
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
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
                            .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
                        }
                    }
                }
            }
            .navigationTitle("Robot Commander")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { value in
//                switch value {
//                case "CalibrateView":
                    CalibrateView()
//                case "ControlView":
//                    DriveView()
//                default:
//                    DriveView()
//                }
            }

            Spacer()
            TextEditor(text: $commObject.responseString)
                .frame(height: 200.0)
                .background(Color.yellow)
                .font(.headline)
                .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
