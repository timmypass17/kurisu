//
//  StatsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/18/23.
//

import SwiftUI

struct StatsView<T: Media>: View {
    let media: T

    var body: some View {
        VStack(alignment: .leading) {
            Text("Statistics".uppercased())
            
            StatsCell(title: "Score", image: "t.square", value: media.scoreString)
            StatsCell(title: "Ranked", image: "t.square", value: media.rankString)
            StatsCell(title: "Popularity", image: "t.square", value: media.popularity)
            StatsCell(title: "Members", image: "t.square", value: media.numListUsers)
            StatsCell(title: "Ranked", image: "t.square", value: media.rankString)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(.regularMaterial)
        }
    }
}

#Preview {
    StatsView(media: sampleAnimes[0])
}
