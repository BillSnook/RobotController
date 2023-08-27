//
//  SpeedIndexSelect.swift
//  RobotController
//
//  Created by Bill Snook on 7/26/23.
//

import SwiftUI

struct SpeedIndexSelect: View {
    @State private var selectedIndex: Int = 9
    @State private var forwardReverse = true
    @State private var left: Int = 512
    @State private var leftFloat: CGFloat = 512.0
    @State private var leftString = "512"
    @State private var right: Int = 512
    @State private var rightFloat: CGFloat = 512.0
    @State private var rightString = "512"

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Speed\nIndex")
                    Picker("S", selection: $selectedIndex) {
                        ForEach(-8..<9) { speed in
                            Text("\(speed)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .position(CGPoint(x: 30.0, y: 40.0))
                    .frame(width: 80.0, height: 90.0)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
//                    .background(.blue)
                    VStack {
                        HStack {
                            Text("L")
                            Slider(value: $leftFloat, in: 0...2047, step: 10,
                                   onEditingChanged: { editing in
                                left = Int(leftFloat)
                                leftString = "\(left)"
                            })
                        }
                        HStack {
                            Text("R")
                            Slider(value: $rightFloat, in: 0...2047, step: 10,
                                   onEditingChanged: { editing in
                                right = Int(rightFloat)
                                rightString = "\(right)"
                            })
                        }
                    }
                }
                HStack {
                    Text("L")
                    TextField("0", text: $leftString)
                        .multilineTextAlignment(.center)
                        .frame(width: 80.0)
                        .border(.black)
                    Spacer()
                    Toggle(isOn: $forwardReverse) {
                        if forwardReverse {
                            Text("Forward")
                        } else {
                            Text("Reverse")
                        }
                    }
                    .frame(width: 120.0)
                    Spacer()
                    TextField("Placeholder", text: $rightString)
                        .multilineTextAlignment(.center)
                        .frame(width: 80.0)
                        .border(.black)
                    Text("R")
                }

            }
        }
        Spacer()
    }
}

struct SpeedIndexSelect_Previews: PreviewProvider {
    static var previews: some View {
        SpeedIndexSelect()
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
