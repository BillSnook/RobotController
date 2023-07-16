//
//  StartupView.swift
//  RobotController
//
//  Created by Bill Snook on 6/23/23.
//

import SwiftUI

struct StartupView: View {

    @ObservedObject var commObject = targetPort

    @State private var fullText: String = "Responses show up here."

    var body: some View {
        NavigationStack {
//            VStack {
                Form {
                    Section() {
                        ConnectView()
                    }
                    Section() {
                        if commObject.connectionState == .connected {
                            SendCommandView()
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
                            .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
                            HStack {
                                Button("Status") {
                                    print("Send Status Request")
                                    commObject.sendPi( "D" )
                                    commObject.responseString = "\nSent Status Request\n"
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Range") {
                                    fullText = "Sent Range Request"
                                }
                                .buttonStyle(.bordered)
                                Spacer()
                                Button("Clear") {
                                    commObject.responseString = ""
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
                    Section() {
                        TextEditor(text: $commObject.responseString)
                    }
                }
//            }
            .navigationBarTitle("Robot Commander", displayMode: .inline)
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
