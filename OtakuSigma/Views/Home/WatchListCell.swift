////
////  WatchListCell.swift
////  OtakuSigma
////
////  Created by Timmy Nguyen on 10/22/23.
////

import SwiftUI

struct WatchListCell<T: Media>: View {
    var item: T
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            PosterView(imageURL: item.mainPicture.medium, width: 85, height: 135) // 85, 135

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(item.startSeasonString)
                        .font(.caption)
                    
                    Spacer()

                }
                .foregroundColor(.secondary)

                
                HStack(spacing: 4){
                    Text(item.title)
                }
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.bottom, 5)
                
                GenreView(item: item, maxTags: 2)
                    .font(.caption)
                    .scrollDisabled(true)
                                
                WatchProgressView<T>(
                    progress: item.myListStatus?.progress ?? 0,
                    numEpisodesOrChapters: item.numEpisodesOrChapters,
                    status: item.status)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "clock")

                    Text("Next Episode: ")
                }
                .foregroundColor(.secondary)
                .font(.caption)
                .padding(.top, 10)
                
                Spacer()
            }

        }
        .frame(height: 135)
        .padding()
    }
}

struct WatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        WatchListCell(item: sampleAnimes[0])
            .previewLayout(.sizeThatFits)
    }
}
