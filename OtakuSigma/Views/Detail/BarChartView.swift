//
//  UserStatsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/18/23.
//

import SwiftUI
import Charts

struct BarChartItem: Identifiable, Comparable {
    var value: Double
    var category: String
    var id = UUID()
    
    static func < (lhs: BarChartItem, rhs: BarChartItem) -> Bool {
        return lhs.value > rhs.value
    }
}

struct BarChartView: View {
    let data: [BarChartItem]
    var showAnnotations = false

    var maxChartValue: Double {
        data.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        VStack {
            Chart(data) { item in
                
                BarMark(
                    x: .value("Value", item.value)
                )
                .cornerRadius(0)
                .foregroundStyle(by: .value("Category", "\(item.category) (\(Int(item.value)))"))
                .annotation(position: .overlay, alignment: .center) {
//                    if showAnnotations {
//                        Text("\(Int(item.value))")
//                            .font(.caption)
//                            .fontWeight(.semibold)
//                    }
                }
            }
            .frame(height: 75)
            .chartLegend(spacing: 10)
//            .frame(height: 75)
            .chartXScale(domain: 0...maxChartValue)
        }
    }

}


#Preview {
    BarChartView(data: sampleAnimes[0].statistics?.toChartData() ?? [])
}
