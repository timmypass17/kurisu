//
//  WatchList.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct WatchListView<T: Media>: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    let service = MALService()
    
    var body: some View {
        LazyVStack(spacing: 16) {
            Divider()
            
            ForEach(homeViewModel.appState.userAnimeList[homeViewModel.selectedAnimeStatus, default: []], id: \.id) { item in
                NavigationLink {
                    MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(media: item as! T, userListStatus: homeViewModel.appState.getListStatus(for: item.id), appState: homeViewModel.appState))
                } label: {
                    WatchListCell(item: item)
                }
                .padding(.horizontal, 16)
                .buttonStyle(.plain)
//                .onAppear {
//                    print("objectWillChange")
//                    // Manual refresh ui, for some reason when updating progress from discover, ui does not change.
//                    homeViewModel.objectWillChange.send()
//                }

                Divider()
                    .padding(.horizontal, 16)
            }
        }
        .padding(.top, 8)
        .onAppear {
            print("objectWillChange")
            // Manual refresh ui, for some reason when updating progress from discover, ui does not change.
            homeViewModel.objectWillChange.send() // this is was @Published does under the hood
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-send-state-updates-manually-using-objectwillchange
        }

    }
    
//    func handleUpdatedMedia(media: Media, updatedMedia: Media) {
//        if let index = items.firstIndex(where: { $0.id == updatedMedia.id }) {
//            // Item changed status
//            if media.myListStatus!.status != updatedMedia.myListStatus!.status {
//                // Remove item
//                items.remove(at: index)
//                isShowingAddMediaView[media.id] = nil
//            } else {
//                // Update item
//                items[index] = updatedMedia as! T
//            }
//        }
//    }
}

//struct WatchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchListView(items: [])
//    }
//}
