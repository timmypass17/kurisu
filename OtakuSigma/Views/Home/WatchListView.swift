//
//  WatchList.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct WatchListView<T: Media>: View {
//    @EnvironmentObject var homeViewModel: HomeViewModel // causes 100% CPU, maybe because we have @Binding items already? Infinite loop
    @EnvironmentObject var homeViewModel: HomeViewModel
    var items: [T] // causes 100% CPu
    @State private var isShowingAddMediaView: [Int: Bool] = [:]
    @State private var isShowingDeleteAlert: Bool = false

    let service = MALService()
    
    var body: some View {
        LazyVStack(spacing: 16) {
            Divider()
            
            ForEach(items, id: \.id) { item in
                NavigationLink {
                    MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(media: item, userListStatus: homeViewModel.getListStatus(for: item.id)))
                } label: {
                    WatchListCell(item: item)
                }
                .padding(.horizontal, 16)
                .buttonStyle(.plain)
                .sheet(isPresented: Binding(
                    get: { isShowingAddMediaView[item.id] ?? false },
                    set: { isShowingAddMediaView[item.id] = $0 }
                )) {
                    NavigationStack {
                        AddMediaView(addMediaViewModel: AddMediaViewModel(media: item))
                    }
                }
//                .alert("Remove Anime?",
//                       isPresented: $isShowingDeleteAlert) {
//                    Button(role: .destructive) {
//                        // Handle the deletion.
//                        Task {
//                            let _ : T? = try await service.deleteMediaItem(id: item.id)
//                            if let index = items.firstIndex(where: { $0.id == item.id }) {
//                                items.remove(at: index)
//                            }
//                        }
//                    } label: {
//                        Text("Delete")
//                    }
//                } message: {
//                    Text("Are you sure you want to remove \"\(item.title)\" from your collection?")
//                }


                Divider()
                    .padding(.horizontal, 16)
            }
        }
        .padding(.top, 8)

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
