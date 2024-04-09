//
//  SearchCell.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/30/23.
//

import SwiftUI

struct SearchCellView: View {
    var item: Media
    var scoreString: String {
        if let score = item.mean {
            return String(format: "%.2f", score)
        }
        
        return "-"
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            PosterView(imageURL: item.mainPicture.medium, width: 100, height: 140)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(item.startSeasonString)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
//                    Label("8.64", systemImage: "star.fill")
//                        .foregroundColor(.secondary)
//                        .font(.caption)
                }
                
                HStack(spacing: 4){
                    Text(item.title)
                }
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.bottom, 5)
                
                GenreView(item: item, maxTags: 2)
                    .font(.caption)
                    .scrollDisabled(true)
                    .padding(.bottom, 10)
                
                HStack {
                    Label(scoreString, systemImage: "star.fill")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Circle()
                        .frame(width: 3)
                    
                    
                    Label("\(item.numEpisodesOrChapters) Episodes",
                          systemImage: "tv"
                    )
                    .font(.system(size: 12))
                    
//                    Label("24 mins", systemImage: "clock")
//                        .font(.system(size: 12))
                }
                .foregroundColor(.secondary)
                
//                Divider()
//                    .padding(.vertical, 8)
                Text(item.synopsis)
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                    .padding(.top, 8)
                
//                HStack {
//                    VStack(spacing: 2) {
//                        Text("Score".uppercased())
//                            .fontWeight(.semibold)
//                            .padding(.vertical, 2)
//                            .padding(.horizontal, 5)
//                            .unredacted()
//
//                        HStack(spacing: 4) {
//                            Text("8.65")
//                        }
//                    }
//
//                    VStack(spacing: 2) {
//                        Text("Rank".uppercased())
//                            .fontWeight(.semibold)
//                            .padding(.vertical, 2)
//                            .padding(.horizontal, 5)
//                            .unredacted()
//
//                        HStack(spacing: 0) {
//                            Image(systemName: "number")
//
//                            Text("65")
//                        }
//                    }
//
//                    VStack(spacing: 2) {
//                        Text("Popularity".uppercased())
//                            .fontWeight(.semibold)
//                            .padding(.vertical, 2)
//                            .padding(.horizontal, 5)
//                            .unredacted()
//
//                        HStack(spacing: 4) {
//                            Image(systemName: "person.2")
//
//                            Text("1.1M")
//                        }
//                    }
//                }
//                .font(.caption)
//                .foregroundColor(.secondary)
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
