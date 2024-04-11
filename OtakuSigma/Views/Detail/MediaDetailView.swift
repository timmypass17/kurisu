//
//  MediaDetailView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct MediaDetailView<T: Media>: View {
    @StateObject var mediaDetailViewModel: MediaDetailViewModel<T>

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                DetailTopSection(media: mediaDetailViewModel.media)

                GenreRowView(genres: mediaDetailViewModel.media.genres.map { $0.name })
                    .font(.caption)
                    .padding(.top)

                DetailProgressView(media: mediaDetailViewModel.media)
                    .padding(.top)

                DetailTabView(selectedTab: $mediaDetailViewModel.selectedTab)
                    .padding(.top)
                
                switch mediaDetailViewModel.selectedTab {
                case .background:
                    SynopsisView(text: mediaDetailViewModel.media.synopsis)
                        .padding(.top)
                    
                    if !mediaDetailViewModel.media.relatedAnime.isEmpty {
                        RelatedRowView<Anime>(relatedItems: mediaDetailViewModel.media.relatedAnime)
                            .padding(.top)
                    }
                    
                    if !mediaDetailViewModel.media.relatedManga.isEmpty {
                        RelatedRowView<Manga>(relatedItems: mediaDetailViewModel.media.relatedManga)
                            .padding(.top)
                    }
                    
                    if !mediaDetailViewModel.media.recommendations.isEmpty {
                        RecommendedRowView<T>(recommendedItems: mediaDetailViewModel.media.recommendations)
                            .padding(.top)
                    }
                case .info:
                    InfoView(media: mediaDetailViewModel.media)
                        .padding(.top)
                    
                    
                case .statistic:
                    StatsView(media: mediaDetailViewModel.media)
                        .padding(.top)
                    
                    if let anime = mediaDetailViewModel.media as? Anime {
                        BarChartView(data: anime.statistics.toChartData())
                            .padding(.top)
//                                .frame(width: .infinity)
                    }
                }
                
                
            }
            .padding()
            .padding(.top)
            Spacer()
        }
        .navigationTitle(mediaDetailViewModel.media.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $mediaDetailViewModel.isShowingAddMediaView, content: {
            NavigationStack {
                AddMediaView(addMediaViewModel: AddMediaViewModel(media: mediaDetailViewModel.media))
            }
        })
        .toolbar {
            ToolbarItemGroup {
                Button {
                    mediaDetailViewModel.isShowingAddMediaView = true
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
        .background(Color.ui.background)

    }
}

//struct MediaDetailView_Previews: PreviewProvider {
//    static var viewmodel: MediaDetailViewModel<Anime> {
//        let vm = MediaDetailViewModel<Anime>(id: sampleAnimes[0].id, mediaService: MALService())
//        vm.state = .success(media: sampleAnimes[0])
//        return vm
//    }
//    static var previews: some View {
//        NavigationStack {
//            MediaDetailView<Anime>(mediaDetailViewModel: viewmodel, didSaveMedia: {_ in})
//        }
//    }
//}
