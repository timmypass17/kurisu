////
////  WatchListCell.swift
////  OtakuSigma
////
////  Created by Timmy Nguyen on 10/22/23.
////

import SwiftUI


struct WatchListCell: View {
    var item: Media

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            PosterView(imageURL: item.mainPicture.large, width: 85, height: 135, includeBorder: false)
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.startSeasonString)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    HStack(spacing: 4){
                        Text(item.getTitle())
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.bottom, 5)
                    
                    GenreRow(genres: item.genres, tagCount: 2)
                        .font(.caption)
                        .scrollDisabled(true)
                }
                
                ProgressView(
                    value: Float(item.myListStatus?.progress ?? 0),
                    total: Float(item.numEpisodesOrChapters)
                ) {
                    HStack(spacing: 4) {
                        AiringView(status: item.status)
                        
                        Spacer()
                        
                        Text("\(item.getEpisodeOrChapterString().capitalized): ")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("\(Int(item.myListStatus?.progress ?? 0)) /")
                            .font(.caption)
                        
                        Group {
                            if item.numEpisodesOrChapters == 0 {
                                Text("?")
                            } else {
                                Text("\(item.numEpisodesOrChapters)")
                            }
                        }
                        .font(.caption)
                        
                    }
                    
                }
                .progressViewStyle(.linear)
                
                MediaStatusView(item: item)

            }
        }
        .contentShape(Rectangle())
    }
}

struct WatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        WatchListCell(item: sampleAnimes[0])
            .previewLayout(.sizeThatFits)
        
    }
}
