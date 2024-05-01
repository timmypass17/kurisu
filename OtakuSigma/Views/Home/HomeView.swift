//
//  ContentView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView(.vertical) {
            Group {
                if homeViewModel.selectedMediaType == .anime {
                    StatusPickerView(selectedStatus: $homeViewModel.selectedAnimeStatus)
                        .padding(.horizontal)
                    
                    WatchListView(data: appState.userAnimeList[homeViewModel.selectedAnimeStatus, default: []])
                } else {
                    StatusPickerView(selectedStatus: $homeViewModel.selectedMangaStatus)
                        .padding(.horizontal)
                    
                    WatchListView(data: appState.userMangaList[homeViewModel.selectedMangaStatus, default: []])
                }
            }
            .searchable(text: $homeViewModel.filteredText, prompt: "Filter by title") {
                if homeViewModel.selectedMediaType == .anime {
                    WatchListView(data: homeViewModel.filteredUserAnimeList)
                } else {
                    WatchListView(data: homeViewModel.filteredUserMangaList)
                }
            }
            .toolbar {
                Button {
                    homeViewModel.didTapMediaButton()
                } label: {
                    Image(systemName: homeViewModel.mediaImage)
                }
            }
        }
        .navigationTitle(homeViewModel.title)
        .overlay {
            if !appState.isLoggedIn {
                LoginOverlayView()
            }
        }
        .background(Color.ui.background)
    }
}
