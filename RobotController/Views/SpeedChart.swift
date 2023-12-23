//
//  SpeedChart.swift
//  RobotController
//
//  Created by Bill Snook on 12/22/23.
//

import SwiftUI
import Charts

struct SpeedChart: View {
    var body: some View {
        Chart {
//            ForEach(speedIndex.singleArray) { entry in
//                PointMark(x: .value("Index", "index"),
//                          y: .value("Value", entry))
//            }
//            for idx in 0...(2 * speedIndex.indexSpace) {
//                let value = speedIndex.externalArray(idx)
////                PointMark(x: <#T##PlottableValue<Plottable>#>, y: <#T##PlottableValue<Plottable>#>)
//            }

            PointMark(
                x: .value("Day", -2),
                y: .value("Min", -512)
            )
            PointMark(
                x: .value("Day", -1),
                y: .value("Min", -256)
            )
            PointMark(
                x: .value("Day", 0),
                y: .value("Min", 0)
            )
            PointMark(
                x: .value("Day", 1),
                y: .value("Min", 256)
            )
            PointMark(
                x: .value("Day", 2),
                y: .value("Min", 512)
            )
        }
        .frame(height: 140)
        .padding()
    }
}

#Preview {
    SpeedChart()
}
