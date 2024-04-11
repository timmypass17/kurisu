//
//  SettingsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var selectedStat: StatPicker = .all
    
    var body: some View {
        switch profileViewModel.appState.state {
        case .unregistered:
            Button("Login") {
//                profileViewModel.loginButtonTapped()
            }
        case .loggedIn(let user):
            
            ScrollView {
                VStack(alignment: .leading) {
                    Picker("Statistic", selection: $selectedStat) {
                        ForEach(StatPicker.allCases) { stat in
                            Text(stat.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding([.horizontal, .top])
                    
                    
                    switch selectedStat {
                    case .all:
                        ProfileStatView(
                            statPicker: selectedStat,
                            listStatusData: profileViewModel.allListStatusData,
                            genreData: profileViewModel.allGenresData,
                            themeData: profileViewModel.allThemesData,
                            demographicData: profileViewModel.allDemographicData
                        )
                    case .anime:
                        ProfileStatView(
                            statPicker: selectedStat,
                            listStatusData: user.animeStatistics.toChartData(),
                            genreData: profileViewModel.animeGenres,
                            themeData: profileViewModel.animeThemes,
                            demographicData: profileViewModel.animeDemographics
                        )
                    case .manga:
                        ProfileStatView(
                            statPicker: selectedStat,
                            listStatusData: profileViewModel.mangaListStatusData,
                            genreData: profileViewModel.mangaGenres,
                            themeData: profileViewModel.mangaThemes,
                            demographicData: profileViewModel.mangaDemographics
                        )
                    }

                }
                
            }
            .navigationTitle(user.name)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.ui.background)
            .toolbar {
                ToolbarItem {
                    Button("Settings", systemImage: "gearshape.fill") {
                        
                    }
                }
            }
            
        case .sessionExpired(_):
            Text("Refresh Token")
        }
    }
}

//#Preview("ProfileView") {
////    let appState = AppState()
//    appState.state = .loggedIn(User.sampleUser)
//    return NavigationStack {
//        ProfileView()
//            .environmentObject(ProfileViewModel(appState: appState, mediaService: MALService()))
//    }
//}

enum StatPicker: String, CaseIterable, Identifiable {
    case all, anime, manga
    
    var id: Self { self }
}
