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
    //    /*@Binding */var userAnimeList: [U : [T]]
    /*@Binding*/ var data: [T]
    
    
    let service = MALService()
    
    var body: some View {
        LazyVStack(spacing: 16) {
            Divider()
            Button("Change Progress") {
                // TODO: We can modify appState's anime list and UI updates
                // Modifing appState's animeList actually updates UI for userAnimeList that was injected!
                appState.userAnimeList[homeViewModel.selectedAnimeStatus]?[0].myListStatus?.progress = 11
            }
            
            ForEach(data, id: \.id) { item in
                NavigationLink {
                    MediaDetailView<T>(
                        mediaDetailViewModel: MediaDetailViewModel(
                            media: item,
                            userListStatus: appState.getListStatus(for: item.id),
                            appState: appState)
                        // TODO: Maybe inject anime as a binding
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
