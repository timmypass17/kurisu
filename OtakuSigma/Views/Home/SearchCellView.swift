//
//  SearchCell.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/30/23.
//

import SwiftUI

struct SearchCellView: View {
    var item: Media

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            PosterView(imageURL: item.mainPicture.large, width: 85, height: 135)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(item.startSeasonString)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                }
                
                HStack(spacing: 4){
                    Text(item.getTitle())
                }
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.bottom, 5)
                
                GenreRow(genres: item.genres, tagCount: 2)
                    .font(.caption)
                    .scrollDisabled(true)
                    .padding(.bottom, 10)

                HStack {
                    Label(item.scoreString, systemImage: "star.fill")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Circle()
                        .frame(width: 3)
                    
                    
                    Label("\(item.numEpisodesOrChapters) Episodes",
                          systemImage: "tv"
                    )
                    .font(.system(size: 12))
                
                }
                .foregroundColor(.secondary)

                Text(item.synopsis)
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                    .padding(.top, 8)
            }

        }
        .padding()
    }
}

struct SearchCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCellView(item: Node(node: sampleAnimes[0]).node)
            .previewLayout(.sizeThatFits)
    }
}
