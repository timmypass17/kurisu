//
//  ContentView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView(.vertical) {
            Group {
                if homeViewModel.selectedMediaType == .anime {
                    StatusPickerView(selectedStatus: $homeViewModel.selectedAnimeStatus)
                        .padding(.horizontal)
                    WatchListView(items: $homeViewModel.userAnimeList)
                } else {
                    StatusPickerView(selectedStatus: $homeViewModel.selectedMangaStatus)
                        .padding(.horizontal)
                    
                    WatchListView(items: $homeViewModel.userMangaList)
                }
            }
            .searchable(text: $homeViewModel.filteredText, prompt: "Filter by title") {
                if homeViewModel.selectedMediaType == .anime {
                    WatchListView(items: $homeViewModel.filteredUserAnimeList)
                } else {
                    WatchListView(items: $homeViewModel.filteredUserMangaList)
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
        .navigationTitle("Anime Tracker")
        .overlay {
            if case .unregistered = homeViewModel.appState.state {
                LoginOverlayView()
            }
        }
        .background(Color.ui.background)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            HomeView()
//                .environmentObject(HomeViewModel(appState: AppState(), mediaService: MALService()))
//        }
//    }
//}
