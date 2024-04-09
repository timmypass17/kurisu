//
//  DiscoverView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0) {
                    DiscoverTabView()
                        .padding([.horizontal, .bottom])
                    
                    Divider()
                    
                    if discoverViewModel.selectedMediaType == .anime {
                        DiscoverListView(sections: discoverViewModel.animeList)
                    } else {
                        DiscoverListView(sections: discoverViewModel.mangaList)
                    }
                }
            }
            .searchable(
                text: $discoverViewModel.searchText,
                prompt: discoverViewModel.selectedMediaType == .anime ? "Search Anime" : "Search Mangas, Novels, etc"
            ) {
                if discoverViewModel.selectedMediaType == .anime {
                    SearchListView<Anime>()
                } else {
                    SearchListView<Manga>()
                }
            }
            .autocorrectionDisabled(true)
            .onSubmit(of: .search) {
                discoverViewModel.submitButtonTapped()
            }
            .onReceive(discoverViewModel.$searchText.debounce(for: 0.5, scheduler: RunLoop.main)
            ) { _ in
                discoverViewModel.searchTextValueChanged()
            }
            .navigationTitle("Discover Anime")
//            .toolbar {
//                NavigationLink {
//                    ArchiveView()
//                } label: {
//                    Image(systemName: "archivebox")
//
//                }
//
//            }
            .background(Color.ui.background)
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscoverView()
                .environmentObject(DiscoverViewModel(mediaService: MALService()))
        }
    }
}

