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

// -8 7 6 5 4 3 2 1 0 1 2 3 4 5 6 7 8   selectedIndex   displayIndex
//  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6   internalIndex   arrayIndex

let speedArrayIndexSpace = 8
let speedArraySpeedIncrements = 256     // 256 for testing should be able to use 512 (2048 vs 4096 top end)

class Speed : ObservableObject {

    static let shared = Speed()

    @Published var left = [Int]()
    @Published var right = [Int]()

    @Published var internalIndex: Int = speedArrayIndexSpace + 1   // Index used internally, 0..(arraySize * 2)

    private init() {
        setup(9)
    }

    var arraySize = speedArrayIndexSpace               // Count of forward or backward speed indexes; normally 8
//    var left = [Int]()
//    var right = [Int]()

    // Setup initial default speed index array
    func setup(_ initialIndex: Int = 0, arraySize: Int = speedArrayIndexSpace) {     // No set speed data yet, create initial array
        self.arraySize = arraySize
        self.internalIndex = initialIndex
        left = Array(repeating: 0, count: arraySize * 2 + 1)
        right = Array(repeating: 0, count: arraySize * 2 + 1)
        for arrayIndex in 0...(arraySize * 2) {
            let displayIndex = arrayIndex - arraySize
            left[arrayIndex] = speedArraySpeedIncrements * abs(displayIndex)
            right[arrayIndex] = speedArraySpeedIncrements * abs(displayIndex)
            print("\(displayIndex): \(left[arrayIndex])  \(right[arrayIndex])")
        }
    }

    var selectedIndex: Int {        // External usage, -arraySize...arraySize
        internalIndex - arraySize
    }

    var leftFloat: Float {
        get {
            Float(left[internalIndex])
        }
        set {
            left[internalIndex] = Int(newValue)
        }
    }

    var leftString: String {
        get {
            String(left[internalIndex])
        }
        set {
            left[internalIndex] = Int(newValue) ?? 0
        }
    }

    var rightFloat: Float {
        get {
            Float(right[internalIndex])
        }
        set {
            right[internalIndex] = Int(newValue)
        }
    }

    var rightString: String {
        get {
            String(right[internalIndex])
        }
        set {
            right[internalIndex] = Int(newValue) ?? 0
        }
    }


// Needs work to accomodate expected string with left and right array data
//    init(_ index: Int = 0, speedFile: String) {
//        self.arraySize = speedArray.count
//        self.speedArray = speedArray
//        self.index = index
//    }

//    func getLeftString(_ index: Int) -> String {
//        return String(left[index])
//    }
//
//    func getRightString(_ index: Int) -> String {
//        return String(right[index])
//    }
//
//    func getLeftFloat(_ index: Int) -> Float {
//        return Float(left[index])
//    }
//
//    func getRightFloat(_ index: Int) -> Float {
//        return Float(right[index])
//    }
//
//    func setLeft(_ index: Int, _ value: Int) {
//        left[index] = value
//    }
//
//    func setRight(_ index: Int, _ value: Int) {
//        right[index] = value
//    }
}
