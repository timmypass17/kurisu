//
//  WatchList.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct WatchListView<T: Media>: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeViewModel: HomeViewModel
    var data: [T]
        
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
            
            ProgressView()
                .opacity(0)
                .onAppear {
                    Task {
                        if homeViewModel.selectedMediaType == .anime {
                            await appState.loadMedia(selectedStatus: homeViewModel.selectedAnimeStatus)
                        } else {
                            await appState.loadMedia(selectedStatus: homeViewModel.selectedMangaStatus)
                        }
                    }
                }
        }
        .padding(.top, 8)
    }
    
}
