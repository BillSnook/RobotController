//
//  ConnectionView.swift
//  RobotController
//
//  Created by Bill Snook on 6/23/23.
//

import SwiftUI

struct ConnectionView: View {
    @ObservedObject var commObject: Sender
    var body: some View {
        VStack {
//            Button(action: {
//                self.commObject.requestConnectionStateChange("Connect")
//            }) {
//                Text(self.commObject.connectionState)
//            }
//            .buttonStyle(.bordered)
            Text(commObject.connectionState.rawValue)
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView(commObject: targetPort)
    }
}
