//
//  SpeedIndexSelect.swift
//  RobotController
//
//  Created by Bill Snook on 7/26/23.
//

import SwiftUI

struct SpeedIndexSetup: View {
    @StateObject private var speed = Speed.shared

//    @State private var leftString = "511"
//    @State private var rightString = "511"

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Speed\nIndex")
                    Picker("S", selection: $speed.internalIndex) {
                        ForEach(-8..<9) { speedIdx in
                            Text("\(speedIdx)")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .position(CGPoint(x: 30.0, y: 40.0))
                    .frame(width: 80.0, height: 90.0)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    VStack {
                        HStack {
                            Text("L")
                            Slider(value: $speed.leftFloat, in: 0...2047, step: 64,
                                   onEditingChanged: { editing in
//                                leftString = String(Int(speed.leftFloat))
//                                speed.left[selectedIndex] = Int(leftFloat)
                            })
                        }
                        HStack {
                            Text("R")
                            Slider(value: $speed.rightFloat, in: 0...2047, step: 64,
                                   onEditingChanged: { editing in
//                                rightString = String(Int(rightFloat))
//                                speed.right[selectedIndex] = Int(rightFloat)
                           })
                        }
                    }
                }
                HStack {
                    Text("L")
                    TextField("0", text: $speed.leftString)
                        .multilineTextAlignment(.center)
                        .frame(width: 80.0)
                        .border(.black)
//                        .onSubmit {
//                            speed.leftString = leftString
////                            speed.left[speed.selectedIndex] = Int(speed.leftString) ?? 0
//                        }
                    Spacer()
                    if speed.selectedIndex >= 0 {
                        Text("Forward")
                            .font(.headline)
                    } else {
                        Text("Reverse")
                            .font(.headline)
                    }
//                    Toggle(isOn: $forwardReverse) {
//                        if forwardReverse {
//                            Text("Forward")
//                        } else {
//                            Text("Reverse")
//                        }
//                    }
//                    .frame(width: 120.0)
                    Spacer()
                    TextField("Placeholder", text: $speed.rightString)
                        .multilineTextAlignment(.center)
                        .frame(width: 80.0)
                        .border(.black)
//                        .onSubmit {
//                            speed.rightString = rightString
////                            speed.right[speed.selectedIndex] = Int(speed.rightString) ?? 0
//                        }
                    Text("R")
                }
            }
        }
    }
}

struct SpeedIndexSelect_Previews: PreviewProvider {
    static var previews: some View {
        SpeedIndexSetup()
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
