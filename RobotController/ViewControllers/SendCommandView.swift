//
//  SendCommandView.swift
//  RobotController
//
//  Created by Bill Snook on 6/28/23.
//

import SwiftUI

struct SendCommandView: View {
    @ObservedObject var commObject = targetPort
    @State private var commandField: String = ""
    
    var body: some View {
        HStack {
            Button("Send") {
                commObject.sendPi( commandField )
                print("Send sent \(commandField)")
            }
                .buttonStyle(.bordered)
            TextField("Type command here", text: $commandField)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
        }
            .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
    }
}

struct SendCommandView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            Section() {
                SendCommandView()
            }
        }
    }
}
