//
//  OtakuSigmaApp.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

@main
struct OtakuSigmaApp: App {
    @StateObject var homeViewModel: HomeViewModel
    @StateObject var discoverViewModel: DiscoverViewModel
    @StateObject var profileViewModel: ProfileViewModel
    
    init() {
        let mediaService = MALService()
        let authService = MALAuthService()
        
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(authService: authService, mediaService: mediaService))
        _discoverViewModel = StateObject(wrappedValue: DiscoverViewModel(mediaService: mediaService))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
                        .environmentObject(homeViewModel)
                }
                .tabItem { Label("List", systemImage: "list.bullet") }
                
                NavigationStack {
                    DiscoverView()
                        .environmentObject(discoverViewModel)
                }
                .tabItem { Label("Discover", systemImage: "magnifyingglass") }
                
                NavigationStack {
                    ProfileView()
                        .environmentObject(profileViewModel)
                }
                .tabItem { Label("Profile", systemImage: "person") }
            }
        }
    }
}


extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let background = Color("background")
    }
}
