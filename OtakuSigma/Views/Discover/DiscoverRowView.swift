//
//  DiscoverRowView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

struct DiscoverRowView<T: Media>: View {
    var ranking: Ranking
    var items: [T]
    
    var body: some View {
        VStack {
            NavigationLink {
                DiscoverDetailView(discoverDetailViewModel: DiscoverDetailViewModel<T>(mediaService: MALService(), ranking: ranking))
            } label: {
                HStack {
                    Text(ranking.description)

                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                }
                .contentShape(Rectangle())
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(items, id: \.id) { item in
                        NavigationLink {
                            MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(id: item.id, mediaService: MALService()))
                        } label: {
                            DiscoverCellView(media: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .frame(minHeight: 175)
            
            Divider()
        }
    }
}
struct DiscoverRowView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverRowView<Anime>(ranking: AnimeRanking.airing, items: sampleAnimes)
    }
}
