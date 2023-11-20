//
//  UserStatsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/18/23.
//

import SwiftUI

struct UserStatsView: View {
    let anime: Anime

    var body: some View {
        VStack(alignment: .leading) {
            Text("Statistics".uppercased())
            
            StatsCell(title: "Watching", image: "t.square", value: getPercentage(numString: anime.statistics.status.watching))
            StatsCell(title: "Completed", image: "t.square", value: getPercentage(numString: anime.statistics.status.completed))
            StatsCell(title: "On Hold", image: "t.square", value: getPercentage(numString: anime.statistics.status.onHold))
            StatsCell(title: "Dropped", image: "t.square", value: getPercentage(numString: anime.statistics.status.dropped))
            StatsCell(title: "Plan To Watch", image: "t.square", value: getPercentage(numString: anime.statistics.status.planToWatch))
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(.regularMaterial)
        }
    }
    
    func getPercentage(numString: String) -> String {
        guard let num = Double(numString) else { return "0.00" }
        let total = Double(anime.numListUsers)
        
        let percentage = Int((num / total) * 100)
        if percentage < 1 {
            return "\(numString) (<1)%)"
        }
        return "\(numString) (\(percentage)%)"
    }
}

#Preview {
    UserStatsView(anime: sampleAnimes[0])
}
