//
//  DiscoverView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appState: AppState
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
                prompt: discoverViewModel.hint
            ) {
                Group {
                    if discoverViewModel.selectedMediaType == .anime {
                        SearchListView<Anime>()
                    } else {
                        SearchListView<Manga>()
                    }
                }
            }
            .autocorrectionDisabled(true)
            .onSubmit(of: .search) {
                discoverViewModel.submitButtonTapped()
            }
            .navigationTitle(discoverViewModel.title)
            .background(Color.ui.background)

        }
    }
}
