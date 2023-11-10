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
        switch mediaDetailViewModel.state {
        case .success(let media):
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    DetailTopSection(media: media)

                    GenreRowView(genres: media.genres.map { $0.name })
                        .font(.caption)
                        .padding(.top)

                    DetailProgressView(
                        media: media,
                        progress: mediaDetailViewModel.listStatus?.progress ?? 0
                    )
                    .padding(.top)

                    //                    DetailTabView(selectedTab: $detailViewModel.selectedTab)
                    //                        .padding(.top)
                    
                    //                    switch detailViewModel.selectedTab {
                    //                    case .background:
                    //                        Synopsis(animeNode: item)
                    //                            .padding(.top)
                    //
                    //                        if let relatedAnimes = (item as? Anime)?.related_anime {
                    //                            RelatedRow(
                    //                                relatedItems: relatedAnimes,
                    //                                type: .anime
                    //                            )
                    //                            .padding(.top)
                    //                        }
                    //
                    //                        if let relatedMangas = (item as? Manga)?.related_manga {
                    //                            RelatedRow(
                    //                                relatedItems: relatedMangas,
                    //                                type: .manga
                    //                            )
                    //                            .padding(.top)
                    //                        }
                    //                    case .statistic:
                    //                        AnimeStats(item: item)
                    //                            .padding(.top)
                    //                    case .recommendation:
                    //                        RecommendationRow(
                    //                            recommendedItems: item?.recommendations ?? [],
                    //                            type: type
                    //                        )
                    //                        .padding(.top)
                    //                    }
                    
                    
                }
                .padding()
                .padding(.top, 115) // 45
                .background(alignment: .top) {
                    //                    if let url = item?.main_picture?.large {
                    //                        DetailBackground(url: url)
                    //                    }
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            //            .navigationTitle(item?.getTitle() ?? "")
            .navigationBarTitleDisplayMode(.inline)
            //            .sheet(isPresented: $detailViewModel.isShowingSheet, onDismiss: { /** Save data **/ }, content: {
            //                NavigationView {
            //                    EpisodeSheet(item: $item, isShowingSheet: $detailViewModel.isShowingSheet, type: type)
            //                }
            //                .presentationDetents([.medium])
            //            })
            .toolbar {
                ToolbarItemGroup {
                    //                if animeViewModel.animeData.contains(where: { $0.node.id == id }) {
                    //                    Button(role: .destructive) {
                    //                        showDeleteAlert = true
                    //                    } label: {
                    //                        Image(systemName: "trash")
                    //
                    //                    }
                    //                }
                    
                    Button(action: { /** detailViewModel.isShowingSheet.toggle()  **/ }) {
                        Image(systemName: "plus") // plus.square
                            .imageScale(.large)
                        
                    }
                }
            }
            //            .onAppear {
            //                Task {
            //                    //                isLoading = true
            //                    item = await animeViewModel.fetchWeebItem(id: id, type: type)
            //                    detailViewModel.isLoading = false
            //                }
            //            }
            //            .alert(
            //                "Delete Progress",
            //                isPresented: $detailViewModel.showDeleteAlert,
            //                presenting: item
            //            ) { animeNode in
            //                Button(role: .destructive) {
            //                    Task {
            //    //                    await animeViewModel.deleteAnime(animeNode: item)
            //                    }
            //                } label: {
            //                    Text("Delete")
            //                }
            //
            //                Button(role: .cancel) {
            //
            //                } label: {
            //                    Text("Cancel")
            //                }
            //            } message: { item in
            //                Text("Are you sure you want to delete your progress for \"\(item.getTitle())\"?")
            //            }
            //        .animation(.easeInOut, value: 1.0)
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
        MediaDetailView<Anime>(mediaDetailViewModel: viewmodel)
    }
}
