//
//  SettingsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingLogOutConfirmation: Bool = false
    
    var body: some View {
        List {
            
            Section("MyAnimeList Info") {
                if !appState.isLoggedIn {
                    Button("Sign In") {
                        appState.didTapLoginButton()
                    }
                } else {
                    ProfileCell(title: "Name", description: "\(appState.userInfo?.name ?? "N/A")", systemName: "person.fill")
                    ProfileCell(title: "Joined At", description: "\(appState.userInfo?.joinedAtDateFormatted ?? "N/A")", systemName: "calendar")
                }
            }
            
            
            Section("Anime Statistics") {
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.all] ?? [])
                            .navigationTitle("All Animes")
                            .onAppear {
                                Task {
                                    await appState.loadUserList(status: AnimeWatchListStatus.all)
                                }
                            }
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Total Entries", description: "\(appState.userInfo?.animeStatistics.numItems ?? 0)", systemName: "chart.bar.fill")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.watching] ?? [])
                            .navigationTitle("Watching")
                            .onAppear {
                                Task {
                                    await appState.loadUserList(status: AnimeWatchListStatus.watching)
                                }
                            }
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Watching", description: "\(appState.userInfo?.animeStatistics.numItemsWatching ?? 0)", systemName: "play.fill")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.completed] ?? [])
                            .navigationTitle("Completed")
                            .onAppear {
                                Task {
                                    await appState.loadUserList(status: AnimeWatchListStatus.completed)
                                }
                            }
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Completed", description: "\(appState.userInfo?.animeStatistics.numItemsCompleted ?? 0)", systemName: "checkmark")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.onHold] ?? [])
                            .navigationTitle("On Hold")
                            .onAppear {
                                Task {
                                    await appState.loadUserList(status: AnimeWatchListStatus.onHold)
                                }
                            }
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "On Hold", description: "\(appState.userInfo?.animeStatistics.numItemsOnHold ?? 0)", systemName: "pause.fill")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.dropped] ?? [])
                            .navigationTitle("Dropped")
                            .onAppear {
                                Task {
                                    await appState.loadUserList(status: AnimeWatchListStatus.dropped)
                                }
                            }
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Dropped", description: "\(appState.userInfo?.animeStatistics.numItemsDropped ?? 0)", systemName: "xmark")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.planToWatch] ?? [])
                            .navigationTitle("Plan To Watch")
                            .onAppear {
                                Task {
                                    await appState.loadUserList(status: AnimeWatchListStatus.planToWatch)
                                }
                            }
                    }
                    .environmentObject(homeViewModel)
                    
                } label: {
                    ProfileCell(title: "Plan To Watch", description: "\(appState.userInfo?.animeStatistics.numItemsPlanToWatch ?? 0)", systemName: "bookmark.fill")
                }
                
            }
            
            Section("Anime Info") {
                ProfileCell(title: "Mean Score", description: "\(appState.userInfo?.animeStatistics.meanScore ?? 0)", systemName: "star.fill")
                ProfileCell(title: "Days", description: "\(appState.userInfo?.animeStatistics.numDays ?? 0)", systemName: "clock")
                ProfileCell(title: "Episodes Watched", description: "\(appState.userInfo?.animeStatistics.numEpisodes ?? 0)", systemName: "tv")
                ProfileCell(title: "Rewatch Count", description: "\(appState.userInfo?.animeStatistics.numTimesRewatched ?? 0)", systemName: "arrow.clockwise")
            }
            
            if appState.isLoggedIn {
                Button("Sign Out", role: .destructive) {
                    isShowingLogOutConfirmation.toggle()
                }
            }
        }
        .confirmationDialog("Are you sure you want to log out?",
                            isPresented: $isShowingLogOutConfirmation,
                            titleVisibility: .visible) {
            Button("Yes") {
                dismiss()
                appState.logOut()
            }
            Button("No", role: .destructive) { }
            Button("Cancel", role: .cancel) {}
        }
                            .navigationTitle("My Profile")
        
        //        Group {
        //            switch appState.state {
        //            case .unregistered:
        ////                Text("Hello")
        //                LoginOverlayView()
        //            case .loggedIn(let userInfo):
        //                List {
        //                    Section("MyAnimeList Info") {
        //                        ProfileCell(title: "Name", description: "\(userInfo.name)", systemName: "person.fill")
        //                        ProfileCell(title: "Joined At", description: "\(userInfo.joinedAtDateFormatted)", systemName: "calendar")
        //                    }
        //
        //
        //                    Section("Anime Statistics") {
        //                        NavigationLink {
        //                            ScrollView {
        //                                WatchListView(data: appState.userAnimeList[.all] ?? [])
        //                                    .navigationTitle("All Animes")
        //                                    .onAppear {
        //                                        Task {
        //                                            await appState.loadUserList(status: AnimeWatchListStatus.all)
        //                                        }
        //                                    }
        //                            }
        //                            .environmentObject(homeViewModel)
        //                        } label: {
        //                            ProfileCell(title: "Total Entries", description: "\(userInfo.animeStatistics.numItems)", systemName: "chart.bar.fill")
        //                        }
        //
        //                        NavigationLink {
        //                            ScrollView {
        //                                WatchListView(data: appState.userAnimeList[.watching] ?? [])
        //                                    .navigationTitle("Watching")
        //                                    .onAppear {
        //                                        Task {
        //                                            await appState.loadUserList(status: AnimeWatchListStatus.watching)
        //                                        }
        //                                    }
        //                            }
        //                            .environmentObject(homeViewModel)
        //                        } label: {
        //                            ProfileCell(title: "Watching", description: "\(userInfo.animeStatistics.numItemsWatching)", systemName: "play.fill")
        //                        }
        //
        //                        NavigationLink {
        //                            ScrollView {
        //                                WatchListView(data: appState.userAnimeList[.completed] ?? [])
        //                                    .navigationTitle("Completed")
        //                                    .onAppear {
        //                                        Task {
        //                                            await appState.loadUserList(status: AnimeWatchListStatus.completed)
        //                                        }
        //                                    }
        //                            }
        //                            .environmentObject(homeViewModel)
        //                        } label: {
        //                            ProfileCell(title: "Completed", description: "\(userInfo.animeStatistics.numItemsCompleted)", systemName: "checkmark")
        //                        }
        //
        //                        NavigationLink {
        //                            ScrollView {
        //                                WatchListView(data: appState.userAnimeList[.onHold] ?? [])
        //                                    .navigationTitle("On Hold")
        //                                    .onAppear {
        //                                        Task {
        //                                            await appState.loadUserList(status: AnimeWatchListStatus.onHold)
        //                                        }
        //                                    }
        //                            }
        //                            .environmentObject(homeViewModel)
        //                        } label: {
        //                            ProfileCell(title: "On Hold", description: "\(userInfo.animeStatistics.numItemsOnHold)", systemName: "pause.fill")
        //                        }
        //
        //                        NavigationLink {
        //                            ScrollView {
        //                                WatchListView(data: appState.userAnimeList[.dropped] ?? [])
        //                                    .navigationTitle("Dropped")
        //                                    .onAppear {
        //                                        Task {
        //                                            await appState.loadUserList(status: AnimeWatchListStatus.dropped)
        //                                        }
        //                                    }
        //                            }
        //                            .environmentObject(homeViewModel)
        //                        } label: {
        //                            ProfileCell(title: "Dropped", description: "\(userInfo.animeStatistics.numItemsDropped)", systemName: "xmark")
        //                        }
        //
        //                        NavigationLink {
        //                            ScrollView {
        //                                WatchListView(data: appState.userAnimeList[.planToWatch] ?? [])
        //                                    .navigationTitle("Plan To Watch")
        //                                    .onAppear {
        //                                        Task {
        //                                            await appState.loadUserList(status: AnimeWatchListStatus.planToWatch)
        //                                        }
        //                                    }
        //                            }
        //                            .environmentObject(homeViewModel)
        //
        //                        } label: {
        //                            ProfileCell(title: "Plan To Watch", description: "\(userInfo.animeStatistics.numItemsPlanToWatch)", systemName: "bookmark.fill")
        //                        }
        //
        //                    }
        //
        //                    Section("Anime Info") {
        //                        ProfileCell(title: "Mean Score", description: "\(userInfo.animeStatistics.meanScore)", systemName: "star.fill")
        //                        ProfileCell(title: "Days", description: "\(userInfo.animeStatistics.numDays)", systemName: "clock")
        //                        ProfileCell(title: "Episodes Watched", description: "\(userInfo.animeStatistics.numEpisodes)", systemName: "tv")
        //                        ProfileCell(title: "Rewatch Count", description: "\(userInfo.animeStatistics.numTimesRewatched)", systemName: "arrow.clockwise")
        //                    }
        //
        //                    Button("Sign Out", role: .destructive) {
        //                        isShowingLogOutConfirmation.toggle()
        //                    }
        //                }
        //                .confirmationDialog("Are you sure you want to log out?",
        //                                    isPresented: $isShowingLogOutConfirmation,
        //                                    titleVisibility: .visible) {
        //                    Button("Yes") {
        //                        dismiss()
        //                        appState.logOut()
        //                    }
        //                    Button("No", role: .destructive) { }
        //                    Button("Cancel", role: .cancel) {}
        //                }
        //            case .sessionExpired(let userInfo):
        //                Text("Session expired")
        //            }
        //        }
        //        .navigationTitle("My Profile")
        
    }
}
