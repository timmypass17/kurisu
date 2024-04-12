//
//  DiscoverDetailView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/6/23.
//

import SwiftUI

struct DiscoverDetailView<T: Media>: View {
    @EnvironmentObject var discoverViewModel: DiscoverViewModel
    @StateObject var discoverDetailViewModel: DiscoverDetailViewModel<T>
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(discoverDetailViewModel.items, id: \.id) { item in
                    NavigationLink {
                        MediaDetailView<T>(mediaDetailViewModel: MediaDetailViewModel(media: item, userListStatus: discoverViewModel.appState.getListStatus(for: item.id), appState: discoverViewModel.appState))
                    } label: {
                        DiscoverDetailCellView(item: item)
                    }
                }
                
                ProgressView()
                    .onAppear {
                        discoverDetailViewModel.loadMedia()
                    }
            }
            .padding(.top)
            .navigationTitle(discoverDetailViewModel.ranking?.description ?? "")
        }
    }
}

//struct DiscoverDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverDetailView(discoverDetailViewModel: DiscoverDetailViewModel())
//    }
//}
