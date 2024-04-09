////
////  WatchListCell.swift
////  OtakuSigma
////
////  Created by Timmy Nguyen on 10/22/23.
////

import SwiftUI


struct WatchListCell<T: Media>: View {
    var item: T
    
    var score: String {
        if let score = item.myListStatus?.score, score != 0{
            return "\(score)"
        }
        return "-"
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            DetailPoster(poster: item.mainPicture, width: 85.0, height: 135.0)
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(item.startSeasonString)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    HStack(spacing: 4){
                        Text(item.title)
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.bottom, 5)
                    
                    GenreRow(animeNode: item, maxTags: 2)
                        .font(.caption)
                        .scrollDisabled(true)
                }
                
                ProgressView(
                    value: Float(1),
                    total: Float(10)
                ) {
                    HStack(spacing: 4) {
                        AnimeStatusViewOld(item: item)
                            .font(.caption)
                        
                        Spacer()
                        Text("Episodes")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("1 /")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("10")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                    }
                    
                }
                .progressViewStyle(.linear)
                
                HStack {
                    Image(systemName: "clock")
                    
                    Text("Next Episode: )")
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
    }
}

struct WatchListCell_Previews: PreviewProvider {
    static var previews: some View {
        WatchListCell<Anime>(item: sampleAnimes[0])
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
    let animeNode: Media?
    var maxTags = Int.max
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(animeNode?.genres.prefix(maxTags) ?? [], id: \.name) { tag in
                    TagView(text: tag.name)
                }
                
                if animeNode?.genres.count ?? 0 > maxTags {
                    HStack(spacing: 0) {
                        Image(systemName: "plus")
                        Text("\((animeNode?.genres.count ?? 0) - maxTags) more")
                    }
                    .foregroundColor(.secondary)
                    .padding(.leading, 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AnimeStatusViewOld: View {
    let item: Media
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Circle()
                .fill(item.airingStatusColor)
                .frame(width: 5)
                .padding(.top, 2)
            
            Text(item.status)
                .font(.system(size: 10))
                .lineLimit(1)
            //                    .foregroundColor(Color.ui.textColor)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
        .background{
            RoundedRectangle(cornerRadius: 2)
                .fill(.regularMaterial)
        }
    }
}

