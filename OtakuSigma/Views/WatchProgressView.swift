//
//  WatchProgressView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/24/23.
//

import SwiftUI

struct WatchProgressView<T: Media>: View {
    let progress: Int
    let numEpisodesOrChapters: Int
    let status: String
    
    var body: some View {
        ProgressView(
            value: Float(progress),
            total: Float(numEpisodesOrChapters)
        ) {
            HStack(spacing: 4) {
                AiringStatusView(status: status)
                    .font(.caption)
                
                Spacer()
                HStack {
                    
                    Text(T.episodeOrChaptersString)
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text("\(progress) /") // TOOD: Use user's watchlist
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text("\(numEpisodesOrChapters)")
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
                .borderedTag()
            }
            
        }
        .progressViewStyle(.linear)
        
    }
}

struct WatchProgressView_Previews: PreviewProvider {
    static var previews: some View {
        WatchProgressView<Anime>(progress: 6, numEpisodesOrChapters: 12, status: "Finished Airing")
    }
}
