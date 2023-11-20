//
//  RelatedRowView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/16/23.
//

import SwiftUI

struct RelatedRowView<T: Media>: View {
    let relatedItems: [RelatedItem]
    
    var body: some View {
        if relatedItems.count > 0 {
            VStack(alignment: .leading) {
                Text(T.relatedItemString)

                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(relatedItems, id: \.node.id) { item in
                            NavigationLink {
                                MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(id: item.node.id, mediaService: MALService()))
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
}

#Preview {
    RelatedRowView<Anime>(relatedItems: [])
}
