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
            
            DetailPoster(poster: item.mainPicture, width: 85.0, height: 135.0)
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.startSeasonString)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    HStack(spacing: 4){
                        Text(item.title)
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
                        
                        Text("\(item.episodeOrChapterString()): ")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("\(Int(item.myListStatus?.progress ?? 0)) /")
//                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Group {
                            if item.numEpisodesOrChapters == 0 {
                                Text("?")
                            } else {
                                Text("\(item.numEpisodesOrChapters)")
                            }
                        }
//                        .foregroundColor(.secondary)
                        .font(.caption)
                        
                    }
                    
                }
                .progressViewStyle(.linear)
                
                MediaStatusView(item: item)

            }
        }
    }
}

struct WatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        WatchListCell(item: sampleAnimes[0])
            .previewLayout(.sizeThatFits)
        
    }
}

struct DetailPoster: View {
    let poster: MainPicture?
    var width: CGFloat
    var height: CGFloat
    
    
    var body: some View {
        if let poster = poster {
            AsyncImage(url: URL(string: poster.medium)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.secondary)
                    }
                    .shadow(radius: 2)
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: height)
            }
        } else {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(.placeholderText))
                .frame(width: width, height: height)
        }
    }
}


struct GenreRow: View {
    let genres: [Genre]
    var tagCount = Int.max
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(genres.prefix(tagCount), id: \.name) { tag in
                    TagView(text: tag.name)
                }
                
                if genres.count > tagCount {
                    HStack(spacing: 0) {
                        Image(systemName: "plus")
                        Text("\((genres.count) - tagCount) more")
                    }
                    .foregroundColor(.secondary)
                    .padding(.leading, 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
