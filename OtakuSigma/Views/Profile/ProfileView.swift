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
    @State var isShowingDeleteConfirmation: Bool = false

    var body: some View {
        List {
            
            Section("MyAnimeList Info") {
                if !appState.isLoggedIn {
                    Button("Sign In") {
                        appState.isPresentMALLoginWebView = true
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
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Total Entries", description: "\(appState.userInfo?.animeStatistics.numItems ?? 0)", systemName: "chart.bar.fill")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.watching] ?? [])
                            .navigationTitle("Watching")
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Watching", description: "\(appState.userInfo?.animeStatistics.numItemsWatching ?? 0)", systemName: "play.fill")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.completed] ?? [])
                            .navigationTitle("Completed")
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Completed", description: "\(appState.userInfo?.animeStatistics.numItemsCompleted ?? 0)", systemName: "checkmark")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.onHold] ?? [])
                            .navigationTitle("On Hold")
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "On Hold", description: "\(appState.userInfo?.animeStatistics.numItemsOnHold ?? 0)", systemName: "pause.fill")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.dropped] ?? [])
                            .navigationTitle("Dropped")
                    }
                    .environmentObject(homeViewModel)
                } label: {
                    ProfileCell(title: "Dropped", description: "\(appState.userInfo?.animeStatistics.numItemsDropped ?? 0)", systemName: "xmark")
                }
                
                NavigationLink {
                    ScrollView {
                        WatchListView(data: appState.userAnimeList[.planToWatch] ?? [])
                            .navigationTitle("Plan To Watch")
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
                Section {
                    Button("Sign Out", role: .destructive) {
                        isShowingLogOutConfirmation.toggle()
                    }
                }
            }
            
            if appState.isLoggedIn {
                Section {
                    Button("Delete Account", role: .destructive) {
                        isShowingDeleteConfirmation.toggle()
                    }
                }
            }
        }
        .confirmationDialog("Are you sure you want to sign out?",
                            isPresented: $isShowingLogOutConfirmation,
                            titleVisibility: .visible) {
            Button("Yes") {
                dismiss()
                appState.logOut()
            }
            Button("No", role: .destructive) { }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Delete MAL Account?",
                            isPresented: $isShowingDeleteConfirmation,
                            titleVisibility: .visible) {
            Button("Yes") { appState.isPresentDeleteAccountWebView = true }
            Button("No", role: .destructive) { }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete your account? You will be sent to the MyAnimeList website to request deletion.")
        }
        .navigationTitle("My Profile")
        .refreshable {
            print("Refresh user")
            Task {
                do {
                    let user = try await appState.mediaService.getUser()
                    appState.state = .loggedIn(user)
                } catch {
                    print("Fail to fetch user")
                }
            }
        }
        
    }
}
