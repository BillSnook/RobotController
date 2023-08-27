//
//  Speed.swift
//  RobotController
//
//  Created by Bill Snook on 8/5/23.
//

import Foundation

/// Our robot motor controller accepts speed settings of from 0 to 4096. We want a simple range of 0 to 8.
/// The robot maintains a list of speed settings to send to the motor controller to control the tread speed.
/// We use an index to give us matched speeds so both forward and backward motions are straight lines.
/// To make sure the two tread sides are moving at the same speed, we calibrate the list so both motors
/// receive the correct values to move at the same rate and the robot moves straight when needed.
/// Currently we have 8 speeds forward and 8 backwards, stored on the robot in a file it reads at startup.
/// 1 is the slowest speed for a given direction and 8 is the fastest. Our controller sends these indexes to
/// set the current speed.
class Speed {
    let arrayLimit: Int             // Count of forward and of backward speed indexes
    var index: Int                  // Index when set, -arrayLimit...arrayLimit

    var speedArray: [Int]

    var internalIndex: Int {        // Nominal index setting, 0...(2 * arrayLimit + 1)
        index + arrayLimit
    }

    init(_ arrayLimit: Int, index: Int = 0) {
        self.arrayLimit = arrayLimit
        self.index = index
        speedArray = Array(repeating: 0, count: arrayLimit * 2 + 1)
    }
}
