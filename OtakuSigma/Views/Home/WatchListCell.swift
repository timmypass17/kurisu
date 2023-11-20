////
////  WatchListCell.swift
////  OtakuSigma
////
////  Created by Timmy Nguyen on 10/22/23.
////

import SwiftUI

struct WatchListCell<T: Media, U: ListStatus>: View {
    var item: UserNode<T, U>
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            PosterView(imageURL: item.node.mainPicture.medium, width: 85, height: 135)

            VStack(alignment: .leading, spacing: 0) {
                Text(item.node.startSeasonString)
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                HStack(spacing: 4){
                    Text(item.node.title)
                }
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.bottom, 5)
                
                GenreView(item: item.node, maxTags: 2)
                    .font(.caption)
                    .scrollDisabled(true)
                    .padding(.bottom, 10)
                
                WatchProgressView<T>(
                    progress: item.listStatus.progress,
                    numEpisodesOrChapters: item.node.numEpisodesOrChapters,
                    status: item.node.status)
                .padding(.bottom, 8)
                
                HStack {
                    Image(systemName: "clock")

                    Text("Next Episode: \(item.node.nextEpisodeFormatted)")
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }

        }
        .padding()
    }
}

struct WatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        WatchListCell(item: UserNode(node:  sampleAnimes[0], listStatus: AnimeListStatus(status: "watching", score: 9, numEpisodesWatched: 11, updatedAt: "2017-11-11T19:52:16+00:00")))
            .previewLayout(.sizeThatFits)
    }
}
