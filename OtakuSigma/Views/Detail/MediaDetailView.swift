//
//  MediaDetailView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct MediaDetailView<T: Media>: View {
    @StateObject var mediaDetailViewModel: MediaDetailViewModel<T>
    var didSaveMedia: (T) -> () // pass work even further hehe

    var body: some View {
        switch mediaDetailViewModel.state {
        case .success(let media):
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    DetailTopSection(media: media)

                    GenreRowView(genres: media.genres.map { $0.name })
                        .font(.caption)
                        .padding(.top)

                    DetailProgressView(media: media)
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
                            // TODO: Maybe use charts
                            UserStatsView(anime: anime)
                                .padding(.top)
                        }
                    }
                    
                    
                }
                .padding()
                .padding(.top)
                Spacer()
            }
            .navigationTitle(media.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mediaDetailViewModel.isShowingAddMediaView, content: {
                NavigationStack {
                    AddMediaView(addMediaViewModel: AddMediaViewModel(media: media)) { media in
                        mediaDetailViewModel.state = .success(media: media as! T)
                        didSaveMedia(media)
                    }
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

        case .loading:
            ProgressView()
        case .failure(let error):
            Text("\(error.localizedDescription)")
        }
        
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var viewmodel: MediaDetailViewModel<Anime> {
        let vm = MediaDetailViewModel<Anime>(id: sampleAnimes[0].id, mediaService: MALService())
        vm.state = .success(media: sampleAnimes[0])
        return vm
    }
    static var previews: some View {
        NavigationStack {
            MediaDetailView<Anime>(mediaDetailViewModel: viewmodel, didSaveMedia: {_ in})
        }
    }
}
