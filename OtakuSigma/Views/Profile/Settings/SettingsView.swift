//
//  SettingsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/28/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            List {
                Section("Anime") {
                    NavigationLink {
                        ScrollView {
                            WatchListView(data: appState.userAnimeList[.onHold] ?? [])
                                .navigationTitle("On Hold Animes")
                                .onAppear {
                                    Task {
                                        await appState.loadUserList(status: AnimeWatchListStatus.onHold)
                                    }
                                }
                        }
                    } label: {
                        Text("On Hold")
                    }

                    NavigationLink {
                        ScrollView {
                            WatchListView(data: appState.userAnimeList[.dropped] ?? [])
                                .navigationTitle("Dropped Animes")
                                .onAppear {
                                    Task {
                                        await appState.loadUserList(status: AnimeWatchListStatus.dropped)
                                    }
                                }
                        }
                    } label: {
                        Text("Dropped")
                    }
                }
                
                Section("Manga") {
                    NavigationLink {
                        ScrollView {
                            WatchListView(data: appState.userMangaList[.onHold] ?? [])
                                .navigationTitle("On Hold Mangas")
                                .onAppear {
                                    Task {
                                        await appState.loadUserList(status: MangaReadListStatus.onHold)
                                    }
                                }
                        }
                    } label: {
                        Text("On Hold")
                    }

                    NavigationLink {
                        ScrollView {
                            WatchListView(data: appState.userMangaList[.dropped] ?? [])
                                .navigationTitle("Dropped Mangas")
                                .onAppear {
                                    Task {
                                        await appState.loadUserList(status: MangaReadListStatus.dropped)
                                    }
                                }
                        }
                    } label: {
                        Text("Dropped")
                    }
                }
                
                Button("Sign Out", role: .destructive) {
                    
                }
            }
            .navigationTitle("Settings")
        }
        
    }
}

#Preview {
    SettingsView()
}
