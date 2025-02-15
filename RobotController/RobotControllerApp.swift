//
//  RobotControllerApp.swift
//  RobotController
//
//  Created by Bill Snook on 6/23/23.
//

import SwiftUI

let targetPort = Sender()
let speedIndex = Speed.shared


@main
struct RobotControllerApp: App {
    var body: some Scene {
        WindowGroup {
            StartupView()
        }
    }
}
