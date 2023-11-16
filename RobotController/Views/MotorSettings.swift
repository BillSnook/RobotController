//
//  MotorSettings.swift
//  RobotController
//
//  Created by Bill Snook on 7/25/23.
//

import SwiftUI

struct MotorSettings: View {
    @State private var left = "0"
    @State private var right = "0"

    var forwardReverse = true
    
    var body: some View {
        HStack {
            Text("L")
            TextField("0", text: $left)
                .multilineTextAlignment(.center)
                .frame(width: 80.0)
//                .cornerRadius(8.0)
                .border(.black)
            Spacer()
            if forwardReverse {
                Text("Forward")
                    .font(.headline)
            } else {
                Text("Reverse")
                    .font(.headline)
            }
//            Toggle(isOn: $forwardReverse) {
//                if forwardReverse {
//                    Text("Forward")
//                } else {
//                    Text("Reverse")
//                }
//            }
//            .frame(width: 120.0)
            Spacer()
            TextField("Placeholder", text: $right)
                .multilineTextAlignment(.center)
                .frame(width: 80.0)
                .border(.black)
//                .cornerRadius(8.0)
            Text("R")
        }
    }
}

struct MotorSettings_Previews: PreviewProvider {
    static var previews: some View {
        MotorSettings()
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
