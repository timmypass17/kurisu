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
    let authService = MALAuthService()
    
    init() {
        let mediaService = MALService()
        let appState = AppState()
    
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(appState: appState, mediaService: mediaService))
        _discoverViewModel = StateObject(wrappedValue: DiscoverViewModel(mediaService: mediaService))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(appState: appState, mediaService: mediaService))
        
//        Task {
//            await authService.refreshAccessToken()
//        }
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
            .onOpenURL { url in
                // called from ProfileView
                Task {
                    if await generateAccessToken(from: url) {
                        await loadUserData()
                    }
                }
            }
            .onAppear {
                // Have to init in onAppear() because AuthService is a class and StateObject() init has @escaping and it doesnt like that
                homeViewModel.authService = authService
                profileViewModel.authService = authService
                
                Task {
                    // Refresh access token if needed
                    await authService.refreshAccessToken()
                }
            }
        }
    }
    
    func generateAccessToken(from url: URL) async -> Bool {
        guard let codeVerifier = authService.codeVerifier else { return false }
        return await authService.generateAccessToken(from: url, codeVerifier: codeVerifier)
    }
    
    func loadUserData() async {
        do {
            let service = MALService()
            let user = try await service.getUser()
            profileViewModel.appState.state = .loggedIn(user)
            await homeViewModel.getUserAnimeList()
//            let additionalUserAnimeListInfo: [AnimeGenreItem] = try await service.getAdditionalUserListInfo()
//            let genres = additionalUserAnimeListInfo.reduce(into: [String : Int]()) { category, item in
//                item.node.genre.forEach { genre in
//                    category[genre.name, default: 0] += 1
//                }
//            }
//            print(genres.count)
//            print(genres.forEach { print("\($0.key) \($0.value)") })

        } catch {
            print("error loading user data: \(error)")
        }
    }
}


extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let background = Color("background")
    }
}
