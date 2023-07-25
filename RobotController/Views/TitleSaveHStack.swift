//
//  TitleSaveHStack.swift
//  RobotController
//
//  Created by Bill Snook on 7/15/23.
//

import SwiftUI

struct TitleSaveHStack: View {
    let fileLead = "/home/data/"
    let fileType = ".dat"
    
    let title: String
    let fileName: String

    var body: some View {
        HStack {
            Button("Reset") {
                print("Reset button action")
                resetFile()
            }
            .buttonStyle(.bordered)
            
            Spacer()
            Text(title)
            Spacer()
            Button("Save") {
                print("Save button action")
                saveFile()
            }
            .buttonStyle(.bordered)
        }
    }

    private func getFilePath() -> String {
        return fileLead + fileName + fileType
    }

    private func resetFile() {
        print("Resetting file at \(getFilePath())")
        // TBD
    }

    private func saveFile() {
        print("Saving file at \(getFilePath())")
        // TBD
    }
}

struct TitleSaveHStack_Previews: PreviewProvider {
    static var previews: some View {
        TitleSaveHStack(title: "Alignment", fileName: "AlignmentTest")
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
