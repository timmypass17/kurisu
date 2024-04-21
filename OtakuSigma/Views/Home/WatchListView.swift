//
//  WatchList.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct WatchListView<T: Media/*, U: MediaListStatus*/>: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeViewModel: HomeViewModel
    var data: [T]
    
    let service = MALService()
    
    var body: some View {
        LazyVStack(spacing: 16) {
            Divider()
            
            ForEach(data, id: \.id) { item in
                NavigationLink {
                    MediaDetailView<T>(
                        mediaDetailViewModel: MediaDetailViewModel(
                            media: item,
                            userListStatus: appState.getListStatus(for: item.id),
                            appState: appState)
                    )
                } label: {
                    WatchListCell(item: item)
                }
                .padding(.horizontal, 16)
                .buttonStyle(.plain)
                
                Divider()
                    .padding(.horizontal, 16)
            }
        }
        .padding(.top, 8)
    }
    
}
