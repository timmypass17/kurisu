//
//  MediaDetailView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct MediaDetailView<T: Media>: View {
    @EnvironmentObject var appState: AppState
    @StateObject var mediaDetailViewModel: MediaDetailViewModel<T>
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                DetailTopSection(media: mediaDetailViewModel.media)

                GenreRowView(genres: mediaDetailViewModel.media.genres.map { $0.name })
                    .font(.caption)
                    .padding(.top)

                DetailProgressView(media: mediaDetailViewModel.media, progress: Double(mediaDetailViewModel.media.myListStatus?.progress ?? 0))
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
        .onAppear {
            if let (media, status, index) = appState.getMediaItem(id: mediaDetailViewModel.media.id) {
                print("Updating progress")
                // TODO: Key is to update progress BOTH locally (mediaDetailViewModel) and globally (appState)
                // Why do I have to update in 2 different places?
                // - We inject a media into the detail viewmodel so the viewmodel has it's own anime instance, separate from appState
                //     - So changes in viewmodel's anime instance are not updating underlying appState's anime list
                //     - TODO: Possible solution is to pass a binding of the anime object to the detailView instead of injecting a separate copy into the viewmodel.
                mediaDetailViewModel.media.myListStatus?.progress = 11
                appState.userAnimeList[status as! AnimeWatchListStatus]?[index].myListStatus?.progress = 11
            }

        }
        .navigationTitle(mediaDetailViewModel.media.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $mediaDetailViewModel.isShowingAddMediaView, content: {
            NavigationStack {
                AddMediaView<T>()
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
        .environmentObject(mediaDetailViewModel)
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
