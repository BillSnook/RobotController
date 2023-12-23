//
//  TitleFileActions.swift
//  RobotController
//
//  Created by Bill Snook on 7/15/23.
//

import SwiftUI

struct TitleFileActions: View {
    let title: String
    let fileName: String

    @State private var presentLoadDialog = false
    @State private var presentSaveDialog = false

    var body: some View {
        HStack {
            Button("Load") {
                print("Loading speed index file")
                presentLoadDialog = true
            }
            .buttonStyle(.bordered)
            .confirmationDialog(
                "This will reload the speed index entries from the device",
                isPresented: $presentLoadDialog)
            {
                Button("Reload from the device", role: .destructive) {
                    print("Resetting to device index entries")
                    loadFile()
                }
            } message: {
                Text("This will replace any unsaved changes with the current device set of entries.\nYou cannot undo this action.")
            }

            Spacer()
            Text(title)
                .font(.headline)
//                .fontWeight(.semibold)
            Spacer()
            Button("Save") {
                print("Saving speed index file changes")
                presentSaveDialog = true
            }
            .buttonStyle(.bordered)
            .confirmationDialog(
                "This will save the speed index entries on the device to it's file",
                isPresented: $presentLoadDialog)
            {
                Button("Save on the device", role: .destructive) {
                    print("Saving device index entries")
                    saveFile()
                }
            } message: {
                Text("This will replace any unsaved changes with the current device set of entries.\nYou cannot undo this action.")
            }
        }
    }

    private func loadFile() {
        targetPort.sendPi("D")  // Request speed file data from device
    }

    private func saveFile() {
        targetPort.sendPi("d")  // Save speed file data on device
    }
}

struct TitleFileActions_Previews: PreviewProvider {
    static var previews: some View {
        TitleFileActions(title: "Alignment", fileName: "AlignmentTest")
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
