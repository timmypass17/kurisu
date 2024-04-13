//
//  OtakuSigmaApp.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

// AppState: Dont add user's anime list here cause arrays/dictionaries are passed by value so 'injecting' the anime list into the other view model will only make a copy :(. Information like user's login state is fine cause we are just reading the value
@main
struct OtakuSigmaApp: App {
    @StateObject var homeViewModel: HomeViewModel
    @StateObject var discoverViewModel: DiscoverViewModel
    let authService = MALAuthService()
    let mediaService = MALService()
    let appState = AppState()   // inject into viewmodels (contains user data)

    init() {
        let homeViewModel = HomeViewModel(appState: appState, mediaService: mediaService, authService: authService)
        let discoverViewModel = DiscoverViewModel(appState: appState, mediaService: mediaService)
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
        _discoverViewModel = StateObject(wrappedValue: discoverViewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
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
            .environmentObject(homeViewModel)
            .onOpenURL { url in
                Task {
                    await handleLogin(url)
                }
            }
        }
    }
    
    func handleLogin(_ url: URL) async {
        guard let tokenResponse = await authService.handleLogin(url: url) else { return }
        do {
            let user = try await mediaService.getUser(accessToken: tokenResponse.accessToken)
            appState.state = .loggedIn(user)
            await appState.loadUserAnimeList()
        } catch {
            print("Error logging in: \(error)")
            appState.state = .unregistered
        }
    }
}


extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let background = Color("background")
    }
}
