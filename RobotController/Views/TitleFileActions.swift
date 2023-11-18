//
//  TitleSaveHStack.swift
//  RobotController
//
//  Created by Bill Snook on 7/15/23.
//

import SwiftUI

struct TitleFileActions: View {
    let fileLead = "/home/data/"
    let fileType = ".dat"
    
    let title: String
    let fileName: String

    var body: some View {
        HStack {
            Button("Load") {
                resetFile()
            }
            .buttonStyle(.bordered)
            
            Spacer()
            Text(title)
                .font(.headline)
//                .fontWeight(.semibold)
            Spacer()
            Button("Save") {
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
        TitleFileActions(title: "Alignment", fileName: "AlignmentTest")
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
