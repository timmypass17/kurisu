//
//  SeasonalView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

enum SeasonalSelection {
    case last
}

struct SeasonalView: View {
    @EnvironmentObject var seasonalViewModel: SeasonalViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            ScrollView {
                VStack(spacing: 0) {
                    Picker("Season", selection: $seasonalViewModel.selectedSeason) {
                        ForEach(SeasonTab.allCases) { tab in
                            Text(tab.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 25)
                    
                    // TOOD: HStack new snap (use for rows)
                    
                    // pinnedview (picker?)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(seasonalViewModel.animes, id: \.id) { anime in
                            DiscoverCellView(item: anime, width: 100)
                        }
                        
                        ProgressView()
                            .onAppear {
//                                Task {
//                                    await seasonalViewModel.loadMoreAnime()
//                                }
                            }
                    }
                    
                }
                .navigationTitle(seasonalViewModel.title)
                .toolbar {
                    Button {
                        // Show archive view
                        print("")
                    } label: {
                        Image(systemName: "archivebox")
                    }

                    Menu {
                        Picker("Sort By", selection: $seasonalViewModel.selectedSort) {
                            ForEach(RankingSort.allCases) { sort in
                                Label(sort.description, systemImage: sort.icon)
                            }
                        }
                    } label: {
                        Label("Add Bookmark", systemImage: "text.alignleft")
                    }
                }
            }
            
        }
    }
}

struct SeasonalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SeasonalView()
                .environmentObject(SeasonalViewModel(mediaService: MALService()))
        }
    }
}
