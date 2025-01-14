//
//  SpeedIndexSetup.swift
//  RobotController
//
//  Created by Bill Snook on 7/26/23.
//

import SwiftUI

struct SpeedIndexSetup: View {
    @ObservedObject var commObject = targetPort

    @ObservedObject var speed = speedIndex

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Speed\nIndex")
                    Picker("S", selection: $speed.internalIndex) {
                        ForEach(-8..<9) { speedIdx in
                            Text("\(speedIdx)")
                                .font(.title2)
                                .fontWeight(.regular)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .position(CGPoint(x: 30.0, y: 40.0))
                    .frame(width: 80.0, height: 90.0)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    VStack {
                        HStack {
                            Text("L")
                            Slider(value: $speed.leftFloat, in: 0...4095, step: 256,
                                   onEditingChanged: { editing in
                               // If running, may want to send updated speed value to device to see result
                                commObject.sendPi("E \(speed.internalIndex) \(speed.left[speed.internalIndex].value) \(speed.right[speed.internalIndex].value)")
                            })
                        }
                        HStack {
                            Text("R")
                            Slider(value: $speed.rightFloat, in: 0...4095, step: 256,
                                   onEditingChanged: { editing in
                                // If running, may want to send updated speed value to device to see result
                                commObject.sendPi("E \(speed.internalIndex) \(speed.left[speed.internalIndex].value) \(speed.right[speed.internalIndex].value)")
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
                        .onSubmit {
                            // If running, may want to send updated speed value to device to see result
                            print("In onSubmit for left string update")
                            commObject.sendPi("E \(speed.internalIndex) \(speed.left[speed.internalIndex].value) \(speed.right[speed.internalIndex].value)")
                        }
                    Spacer()
                    if speed.selectedIndex > 0 {
                        Text("Forward")
                            .font(.headline)
                    } else if speed.selectedIndex == 0 {
                        Text("Stopped")
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
                        .onSubmit {
                            // If running, may want to send updated speed value to device to see result
                            print("In onSubmit for right string update")
                            commObject.sendPi("E \(speed.internalIndex) \(speed.left[speed.internalIndex].value) \(speed.right[speed.internalIndex].value)")
                        }
                    Text("R")
                }
            }
        }
    }
}

struct SpeedIndexSetup_Previews: PreviewProvider {
    static var previews: some View {
        SpeedIndexSetup()
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
