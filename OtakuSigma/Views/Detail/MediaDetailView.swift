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
                .padding(.top, 127) // 45, 115
                .background(alignment: .top) {
                    DetailBackground(url: media.mainPicture.large)
                }
                
//                Spacer()
            }
            .ignoresSafeArea(edges: .top)
//            .edgesIgnoringSafeArea(.top)
            .navigationTitle(media.getTitle())
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
            .toolbarBackground(.visible, for: .navigationBar) // always show it
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

struct DetailBackground: View {
    let url: String

    let gradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color.ui.background, location: 0),
            .init(color: .clear, location: 1.0) // 1.5 height of gradient
        ]),
        startPoint: .bottom,
        endPoint: .top
    )
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 350)
                .clipShape(Rectangle())
                .overlay {
                    gradient
                }
                .clipped()
        } placeholder: {
//            ProgressView()
//                .frame(height: 350)
        }
    }
}
