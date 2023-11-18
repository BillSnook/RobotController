//
//  SpeedActions.swift
//  RobotController
//
//  Created by Bill Snook on 7/25/23.
//

import SwiftUI

struct SpeedFileActions: View {
    @State private var presentDialog = false
    var body: some View {
        HStack {
            Button("Fill Forward") {
                print("Fill Forward button action to fill forward list")
            }
            .buttonStyle(.bordered)

            Spacer()
            Button("Reset") {
                print("Reset button action to set to default speed index settings")
                presentDialog = true
            }
            .buttonStyle(.bordered)
            .confirmationDialog(
                "This will return the speed index to the default settings",
                isPresented: $presentDialog)
            {
                Button("Reset to unmodified state", role: .destructive) {
                    print("Resetting to unmodified state")
                }
            } message: {
                Text("You cannot undo this action.")
            }

            Spacer()
            Button("Fill Reverse") {
                print("Fill Reverse button action to fill reverse list")
            }
            .buttonStyle(.bordered)
        }
    }
}

struct SpeedActions_Previews: PreviewProvider {
    static var previews: some View {
        SpeedFileActions()
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
