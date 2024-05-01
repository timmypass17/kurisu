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
                    
                    GenreRow(genres: media.genres)
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
                        }
                    }
                    
                    Spacer()

                }
                .padding()
                .padding(.top, 127)
                .background(alignment: .top) {
                    BackgroundView(url: media.mainPicture.large)
                }
                
            }
            .ignoresSafeArea(edges: .top)
            .navigationTitle(media.getTitle())
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mediaDetailViewModel.isShowingAddMediaView, content: {
                NavigationStack {
                    AddMediaView<T>(media: media)
                        .onAppear {
                            mediaDetailViewModel.progress = Double(media.myListStatus?.progress ?? 0)
                            mediaDetailViewModel.score = Double(media.myListStatus?.score ?? 0)
                            mediaDetailViewModel.comments = media.myListStatus?.comments ?? ""
                        }
                }
            })
            .toolbarBackground(.visible, for: .navigationBar) // always show toolbar
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
            Color.ui.background
                .ignoresSafeArea()
                .overlay {
                    ProgressView()
                }
                .toolbar {
                    Button {
                        
                    } label: {
                        if mediaDetailViewModel.isInUserList {
                            Image(systemName: "square.and.pencil")
                        } else {
                            Image(systemName: "plus")
                        }
                    }
                    .disabled(true)

                }
        case .failure(let error):
            Text("Error loading media. Please email timmysappstuff@gmail.com to report bugs!")
        }

    }
}
