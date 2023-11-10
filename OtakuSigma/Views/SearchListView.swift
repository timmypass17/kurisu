//
//  SearchListView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI


struct SearchListView<T: Media>: View {
    @EnvironmentObject var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(discoverViewModel.searchResult, id: \.id) { item in
                NavigationLink {
                    MediaDetailView(mediaDetailViewModel: MediaDetailViewModel<T>(id: item.id, mediaService: MALService()))
                } label: {
                    SearchCellView(item: item)
                }
                Divider()
            }
        }
    }
    
}
struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView<Anime>()
            .environmentObject(DiscoverViewModel(mediaService: MALService()))
    }
}
