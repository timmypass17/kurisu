//
//  ProfileStatView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 12/5/23.
//

import SwiftUI
import Charts

struct ProfileStatView: View {
    var statPicker: StatPicker
    var listStatusData: [BarChartItem]
    var genreData: [BarChartItem]
    var themeData: [BarChartItem]
    var demographicData: [BarChartItem]
    
    var title: String { statPicker.rawValue.capitalized }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(.secondary)
            
            Text("List Status")
                .font(.title2)
                .fontWeight(.semibold)
            
            BarChartView(data: listStatusData, showAnnotations: true)
            
            Divider()
                .padding(.vertical)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Text("Top 10 Genres")
                .font(.title2)
                .fontWeight(.semibold)
            
            Chart(genreData) { genre in
                SectorMark(
                    angle: .value("Count", genre.value),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Genre", "\(genre.category) (\(Int(genre.value)))"))
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    if let frame = chartProxy.plotFrame, // nil if no chart
                       let favoriteGenre = genreData.sorted().first?.category {
                        let frame = geometry[frame]
                        VStack {
                            Text("Favorite Genre")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text(favoriteGenre)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
            .frame(height: 300)
            .chartLegend(spacing: 10)
            
            Divider()
                .padding(.vertical)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Text("Top 10 Themes")
                .font(.title2)
                .fontWeight(.semibold)
            
            Chart(themeData) { theme in
                SectorMark(
                    angle: .value("Count", theme.value),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Theme", "\(theme.category) (\(Int(theme.value)))"))
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    if let frame = chartProxy.plotFrame, // nil if no chart
                       let favoriteGenre = themeData.sorted().first?.category {
                        let frame = geometry[frame]
                        VStack {
                            Text("Favorite Theme")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text(favoriteGenre)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
            .frame(height: 300)
            .chartLegend(spacing: 10)
            
            Divider()
                .padding(.vertical)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            
            Text("Demographics")
                .font(.title2)
                .fontWeight(.semibold)
            
            
            BarChartView(data: demographicData, showAnnotations: true)
        }
        .padding()
    }
}

//#Preview {
//    ProfileStatView(statPicker: <#Binding<StatPicker>#>, listStatusData: <#Binding<[BarChartItem]>#>, genreData: <#Binding<[BarChartItem]>#>, themeData: <#Binding<[BarChartItem]>#>, demographicData: <#Binding<[BarChartItem]>#>)
//}
