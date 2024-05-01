//
//  SearchListView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI


struct SearchListView<T: Media>: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(discoverViewModel.searchResult, id: \.id) { item in
                    NavigationLink {
                        MediaDetailView(mediaDetailViewModel:
                                            MediaDetailViewModel(
                                                media: item as! T,
                                                userListStatus: appState.getListStatus(for: item.id),
                                                appState: appState)
                        )
                    } label: {
                        SearchCellView(item: item)
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                }
            }
        }
    }
    
}
