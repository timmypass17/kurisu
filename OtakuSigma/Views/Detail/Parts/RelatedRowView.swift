//
//  RelatedRowView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/16/23.
//

import SwiftUI

struct RelatedRowView<T: Media>: View {
    @EnvironmentObject var appState: AppState
    let relatedItems: [RelatedItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(T.relatedItemString)
            
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(relatedItems, id: \.node.id) { item in
                        NavigationLink {
                            MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(id: item.node.id, appState: appState))
                        } label: {
                            RelatedCellView(relatedItem: item)                                
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#Preview {
    RelatedRowView<Anime>(relatedItems: [])
}
