//
//  WatchProgressView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/24/23.
//

import SwiftUI

struct WatchProgressView<T: Media>: View {
    let score: String
    let progress: Int
    let numEpisodesOrChapters: Int
    let status: String
    
    var body: some View {
        ProgressView(
            value: Float(progress),
            total: Float(numEpisodesOrChapters)
        ) {
            HStack(spacing: 4) {
//                AiringStatusView(status: status.capitalized.replacingOccurrences(of: "_", with: " "))
//                    .font(.caption)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                    Text("\(score)")
                }
                .font(.caption)

//                HStack(spacing: 4) {
//                    
//                    Text("Score:")
//                        .foregroundColor(.secondary)
//                        .font(.caption)
//                    
//                    Text("9")
//                        .foregroundColor(.secondary)
//                        .font(.caption)
//                }
//                
                Spacer()

                HStack(spacing: 4) {
                    
                    Text("\(T.episodesOrChaptersString):")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text("\(progress) /") // TOOD: Use user's watchlist
                        .font(.caption)
                    
                    Text("\(numEpisodesOrChapters)")
                        .font(.caption)
                }
//                .borderedTag()
            }
            
        }
        .progressViewStyle(.linear)
        
    }
}

struct WatchProgressView_Previews: PreviewProvider {
    static var previews: some View {
        WatchProgressView<Anime>(score: "8", progress: 6, numEpisodesOrChapters: 12, status: "Finished Airing")
    }
}
