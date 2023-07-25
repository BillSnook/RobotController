//
//  CalibrateView.swift
//  RobotController
//
//  Created by Bill Snook on 7/17/23.
//

import SwiftUI

struct CalibrateView: View {
    var body: some View {
        VStack {
            Text("Calibrate! 3")
            VStack {
                TitleSaveHStack(title: "Scanner Alignment", fileName: "ScannerAlignment")
                    .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
            }
            .background(Color.clear)
            .cornerRadius(10.0)
            VStack {
                TitleSaveHStack(title: "Speed Alignment", fileName: "SpeedAlignment")
                    .padding(EdgeInsets(top: 4.0, leading: 0.0, bottom: 4.0, trailing: 0.0))
//                ManualSpeedSet()
            }
            Spacer()
        }
    }
}

struct CalibrateView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrateView()
            .padding(EdgeInsets(top: 4.0, leading: 20.0, bottom: 4.0, trailing: 20.0))
    }
}
