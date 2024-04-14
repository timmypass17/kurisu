//
//  RecommendedRowView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/17/23.
//

import SwiftUI

struct RecommendedRowView<T: Media>: View {
    @EnvironmentObject var appState: AppState
    let recommendedItems: [RecommendedItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("You May Also Like (\(recommendedItems.count))")
            
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(recommendedItems, id: \.node.id) { item in
                        NavigationLink {
                            MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(id: item.node.id, appState: appState))
                        } label: {
                            RecommendedCellView(recommendedItem: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#Preview {
    RecommendedRowView<Anime>(recommendedItems: [])
}
