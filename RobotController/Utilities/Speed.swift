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

//            left | right
// -8 7 6 5 4 3 2 1 0 1 2 3 4 5 6 7 8   selectedIndex   displayIndex
//  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6   internalIndex   arrayIndex

let defaultSpeedArrayIndexSpace = 8
let speedArraySpeedIncrements = 128     // 256 for testing should be able to use 512 (2048 vs 4096 top end)

class Speed : ObservableObject {

    static let shared = Speed()

    @Published var left = [Int]()
    @Published var right = [Int]()

    @Published var internalIndex: Int = defaultSpeedArrayIndexSpace + 1    // Index of slowest forward speed at start

    var singleArray = [Int]()

    private var indexSpace = defaultSpeedArrayIndexSpace                   // Number of speed indexes; normally 8 but set by device

    private var hasValidSpeedArray = false                                 // Not loaded initially, using fill in default

    private init() {
        setup()
    }


    // Setup initial default speed index array - used as placeholder if no device version at setup time
    func setup(_ initialIndex: Int = 1) {     // No set speed data yet, create initial array
        guard !hasValidSpeedArray else {
            return
        }
        indexSpace = defaultSpeedArrayIndexSpace
        print("Speed.setup default indexSpace == \(indexSpace)")
        internalIndex = indexSpace + initialIndex
        left = Array(repeating: 0, count: indexSpace * 2 + 1)
        right = Array(repeating: 0, count: indexSpace * 2 + 1)
        for arrayIndex in 0...(indexSpace * 2) {
            let displayIndex = arrayIndex - indexSpace
            left[arrayIndex] = speedArraySpeedIncrements * abs(displayIndex)
            right[arrayIndex] = speedArraySpeedIncrements * abs(displayIndex)
            print("\(displayIndex): \(left[arrayIndex])  \(right[arrayIndex])")
        }
        lrToSingle()
    }

    // Set parameters from response from device with it's speed index data
    func setup(_ message: String, _ initialIndex: Int = 1) {
        let params = message.split(separator: "\n")
        let header = params[0].split(separator: " ")
        guard header.count == 2 else {
            return
        }
        indexSpace = Int( header[1] ) ?? defaultSpeedArrayIndexSpace
        print("Speed.setup devices indexSpace == \(indexSpace)")
        internalIndex = indexSpace + initialIndex
        left = Array(repeating: 0, count: indexSpace * 2 + 1)
        right = Array(repeating: 0, count: indexSpace * 2 + 1)
        // Here we update the Speed object, speed
        for paramString in params {
            let entry = paramString.split(separator: " ")
            if entry[0] != "S" {
                let optIndex = Int( entry[0] )
                let optLeft = Int( entry[1] )
                let optRight = Int( entry[2] )
                if let index = optIndex, let leftValue = optLeft, let rightValue = optRight {
                    let walkingIndex = index + indexSpace
                    if walkingIndex >= 0 {
                        print("\(index), walkingIndex: \(walkingIndex): \(leftValue)  \(rightValue)")
                        left[walkingIndex] = leftValue
                        right[walkingIndex] = rightValue
                    } else {
                        print("Speed.setup error for index == \(index), internalIndex == \(internalIndex)")
                    }
                } else {
                    print("Speed.setup error for index == \(optIndex ?? 999), internalIndex == \(internalIndex)")
                }
            }
        }
        lrToSingle()
        hasValidSpeedArray = true
    }

    func lrToSingle() {
        for idx in 0...(2 * indexSpace) {
            if idx < indexSpace {
                print("lrToSingle,  left, idx: \(idx) value: \(left[idx])")
//                singleArray[idx] = left[idx]
            } else {
                print("lrToSingle, right, idx: \(idx) value: \(right[idx - indexSpace]), idx - indexSpace: \(idx - indexSpace)")
//                singleArray[idx] = right[idx - indexSpace]
            }
        }
    }

    var selectedIndex: Int {        // External usage, -indexSpace...indexSpace
        internalIndex - indexSpace
    }

    var leftFloat: Float {
        get {
            Float(left[internalIndex])
        }
        set {
            left[internalIndex] = Int(newValue)
            singleArray[internalIndex] = Int(newValue)
        }
    }

    var leftString: String {
        get {
            String(left[internalIndex])
        }
        set {
            left[internalIndex] = Int(newValue) ?? 0
            singleArray[internalIndex] = Int(newValue) ?? 0
        }
    }

    var rightFloat: Float {
        get {
            Float(right[internalIndex])
        }
        set {
            right[internalIndex] = Int(newValue)
            singleArray[internalIndex - indexSpace] = Int(newValue)
        }
    }

    var rightString: String {
        get {
            String(right[internalIndex])
        }
        set {
            right[internalIndex] = Int(newValue) ?? 0
            singleArray[internalIndex - indexSpace] = Int(newValue) ?? 0
        }
    }
}
