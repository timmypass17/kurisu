//
//  DiscoverDetailView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/6/23.
//

import SwiftUI

struct DiscoverDetailView<T: Media>: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var discoverViewModel: DiscoverViewModel
    @StateObject var discoverDetailViewModel: DiscoverDetailViewModel<T>
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(discoverDetailViewModel.items, id: \.id) { item in
                        NavigationLink {
                            MediaDetailView<T>(
                                mediaDetailViewModel: MediaDetailViewModel(
                                    media: item,
                                    userListStatus: appState.getListStatus(for: item.id),
                                    appState: appState)
                            )
                        } label: {
                            DiscoverDetailCellView(item: item, width: geometry.size.width * 0.3)
                            
                        }
                        .buttonStyle(.plain)
                    }
                    
                    ProgressView()
                        .onAppear {
                            discoverDetailViewModel.loadMedia()
                        }
                }
                .padding()
                .navigationTitle(discoverDetailViewModel.ranking?.description ?? "")
            }
            .background(Color.ui.background)

        }
    }
}

//struct DiscoverDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverDetailView(discoverDetailViewModel: DiscoverDetailViewModel())
//    }
//}
