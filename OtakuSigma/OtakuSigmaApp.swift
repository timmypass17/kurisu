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
//    @StateObject var profileViewModel: ProfileViewModel
    let authService = MALAuthService()
    let mediaService = MALService()

    init() {
        let homeViewModel = HomeViewModel(mediaService: mediaService, authService: authService)
        let discoverViewModel = DiscoverViewModel(mediaService: mediaService)
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
        _discoverViewModel = StateObject(wrappedValue: discoverViewModel)
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
//                        .environmentObject(profileViewModel)
                }
                .tabItem { Label("Profile", systemImage: "person") }
            }
            .onOpenURL { url in
                Task {
                    await handleLogin(url)
                }
            }
//            .onAppear {
//                Task {
//                    // Refresh access token if needed
//                    await authService.refreshAccessToken()
//                }
//            }
        }
    }
    
    func handleLogin(_ url: URL) async {
        guard let tokenResponse = await authService.handleLogin(url: url) else { return }
        do {
            let user = try await mediaService.getUser(accessToken: tokenResponse.accessToken)
            AppState.shared.state = .loggedIn(user)
            await homeViewModel.loadUserAnimeList()
        } catch {
            AppState.shared.state = .unregistered
        }
    }
}


extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let background = Color("background")
    }
}
