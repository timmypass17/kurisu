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
                    
                    // $userAnimeList[homeViewModel.selectedAnimeStatus, default: []] doesn't compile
                    WatchListView<Anime>(data: appState.userAnimeList[homeViewModel.selectedAnimeStatus, default: []])
                }
            }
            .searchable(text: $homeViewModel.filteredText, prompt: "Filter by title") {
                if homeViewModel.selectedMediaType == .anime {
//                    WatchListView()
                }
//                else {
//                    WatchListView(items: homeViewModel.userMangaList[homeViewModel.selectedMangaStatus, default: []])
//                }
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
//            if !homeViewModel.isLoggedIn {
//                LoginOverlayView()
//            }
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
