//
//  ChartView.swift
//  Polaroid
//
//  Created by gnksbm on 8/6/24.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
struct ChartView: SwiftUI.View {
    @Binding var statistics: [DetailImage.StatisticsData]
    var body: some SwiftUI.View {
        Chart(statistics, id: \.hashValue) {
            LineMark(
                x: .value(
                    "날짜",
                    $0.date
                ),
                y: .value(
                    "값",
                    $0.value
                )
            )
        }
    }
}
