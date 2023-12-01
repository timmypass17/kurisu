//
//  SettingsView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/1/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        switch profileViewModel.appState.state {
        case .unregistered:
            Button("Login") {
                profileViewModel.loginButtonTapped()
            }
        case .loggedIn(let user):
            ScrollView {
                VStack(alignment: .leading) {
//                    Text("Recently Updated")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//
//                    
                    
                    Text("Anime")
                        .font(.title2)
                        .fontWeight(.semibold)

                    BarChartView(data: user.animeStatistics.toChartData())
                    
                    Text("Genres")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)

                }
                .padding()
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

#Preview("ProfileView") {
    let appState = AppState()
    appState.state = .loggedIn(User.sampleUser)
    return NavigationStack {
        ProfileView()
            .environmentObject(ProfileViewModel(appState: appState, mediaService: MALService()))
    }
}
