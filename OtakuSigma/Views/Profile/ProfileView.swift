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
    
    var body: some View {
        NavigationStack {
            switch appState.state {
            case .unregistered:
                Text("Unregistered")
            case .loggedIn(let userInfo):
                List {
                    Section("My Info") {
                        ProfileCell(title: "Name", description: "\(userInfo.name)", systemName: "person.fill")
                        ProfileCell(title: "Joined At", description: "\(userInfo.joinedAtDateFormatted)", systemName: "calendar")
                    }
                    
                    Section("Anime Statistics") {
                        ProfileCell(title: "Total Entries", description: "\(userInfo.animeStatistics.numItems)", systemName: "chart.bar.fill")
                        ProfileCell(title: "Watching", description: "\(userInfo.animeStatistics.numItemsWatching)", systemName: "play.fill", color: .blue)
                        ProfileCell(title: "Completed", description: "\(userInfo.animeStatistics.numItemsCompleted)", systemName: "checkmark", color: .green)
                        ProfileCell(title: "On Hold", description: "\(userInfo.animeStatistics.numItemsOnHold)", systemName: "pause.fill", color: .yellow)
                        ProfileCell(title: "Dropped", description: "\(userInfo.animeStatistics.numItemsDropped)", systemName: "xmark", color: .red)
                        ProfileCell(title: "Plan To Watch", description: "\(userInfo.animeStatistics.numItemsPlanToWatch)", systemName: "bookmark.fill", color: .purple)
                    }
                    
                    Section("Anime Info") {
                        ProfileCell(title: "Mean Score", description: "\(userInfo.animeStatistics.meanScore)", systemName: "star.fill")
                        ProfileCell(title: "Days", description: "\(userInfo.animeStatistics.numDays)", systemName: "clock")
                        ProfileCell(title: "Episodes Watched", description: "\(userInfo.animeStatistics.numEpisodes)", systemName: "tv")
                        ProfileCell(title: "Rewatch Count", description: "\(userInfo.animeStatistics.numTimesRewatched)", systemName: "arrow.clockwise")
                    }
                }
                .navigationTitle("My Profile")
                .toolbar {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                // TOOD: Add settings to show dropped and planning items
            case .sessionExpired(let userInfo):
                Text("Session expired")
            }
        }
    }
}

struct ProfileCell: View {
    var title: String
    var description: String
    var systemName: String
    var color: Color?
    
    var body: some View {
        HStack {
            if let color {
                Image(systemName: systemName)
                //                    .foregroundStyle(color)
            } else {
                Image(systemName: systemName)
            }
            Text(title)
            Spacer()
            Text(description)
                .foregroundStyle(.secondary)
        }
    }
}
