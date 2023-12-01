//
//  UserStatsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/18/23.
//

import SwiftUI
import Charts

struct BarChartItem {
    var value: Double
    var category: String
}

struct BarChartView: View {
    let data: [BarChartItem]

    var maxChartValue: Double {
        data.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        VStack {
            Chart(data, id: \.category) {
                
                BarMark(
                    x: .value("Value", $0.value)
                )
                .foregroundStyle(by: .value("Category", $0.category))
                
            }
            .frame(height: 75)
            .chartXScale(domain: 0...maxChartValue)
        }
    }

}


#Preview {
    BarChartView(data: sampleAnimes[0].statistics.toChartData())
}
