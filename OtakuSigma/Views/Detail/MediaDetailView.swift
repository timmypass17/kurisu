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
        switch mediaDetailViewModel.mediaState {
        case .success(let media):
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    DetailTopSection(media: media)

                    GenreRowView(genres: media.genres.map { $0.name })
                        .font(.caption)
                        .padding(.top)

                    DetailProgressView(media: media, progress: Double(media.myListStatus?.progress ?? 0))
                        .padding(.top)

                    DetailTabView(selectedTab: $mediaDetailViewModel.selectedTab)
                        .padding(.top)
                    
                    switch mediaDetailViewModel.selectedTab {
                    case .background:
                        
                        SynopsisView(text: media.synopsis)
                            .padding(.top)
                        
                        if !media.relatedAnime.isEmpty {
                            RelatedRowView<Anime>(relatedItems: media.relatedAnime)
                                .padding(.top)
                        }
                        
                        if !media.relatedManga.isEmpty {
                            RelatedRowView<Manga>(relatedItems: media.relatedManga)
                                .padding(.top)
                        }
                        
                        if !media.recommendations.isEmpty {
                            RecommendedRowView<T>(recommendedItems: media.recommendations)
                                .padding(.top)
                        }
                    case .info:
                        InfoView(media: media)
                            .padding(.top)
                        
                    case .statistic:
                        StatsView(media: media)
                            .padding(.top)
                        
                        if let anime = media as? Anime {
                            BarChartView(data: anime.statistics.toChartData())
                                .padding(.top)
    //                                .frame(width: .infinity)
                        }
                    }
                    
                    Spacer()

                }
                .padding()
                .padding(.top)
                
//                Spacer()
            }
            .navigationTitle(media.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mediaDetailViewModel.isShowingAddMediaView, content: {
                NavigationStack {
                    AddMediaView<T>(media: media)
                        .onAppear {
                            mediaDetailViewModel.progress = Double(media.myListStatus?.progress ?? 0)
                            mediaDetailViewModel.score = Double(media.myListStatus?.score ?? 0)
                        }
                }
            })
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        mediaDetailViewModel.isShowingAddMediaView = true
                    } label: {
                        if mediaDetailViewModel.isInUserList {
                            Image(systemName: "square.and.pencil")
                        } else {
                            Image(systemName: "plus")
                        }
                    }

                }
            }
            .background(Color.ui.background)
            .environmentObject(mediaDetailViewModel)
        case .loading:
            ProgressView()
        case .failure(let error):
            Text("Error loading media")
        }

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
