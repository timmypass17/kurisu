//
//  OtakuSigmaApp.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import SwiftUI

@main
struct OtakuSigmaApp: App {
    @StateObject var appState: AppState
    @StateObject var homeViewModel: HomeViewModel
    @StateObject var discoverViewModel: DiscoverViewModel
    let authService = MALAuthService()
    let mediaService = MALService()

    init() {
        let appState = AppState(authService: authService)
        let homeViewModel = HomeViewModel(mediaService: mediaService, authService: authService)
        let discoverViewModel = DiscoverViewModel(mediaService: mediaService)
        _appState = StateObject(wrappedValue: appState)
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
        _discoverViewModel = StateObject(wrappedValue: discoverViewModel)
        
        appState.homeViewModel = homeViewModel
        appState.discoverViewModel = discoverViewModel
        homeViewModel.appState = appState
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
                        .environmentObject(homeViewModel)
                        .onAppear {
                            Task {
                                do {
                                    let user = try await mediaService.getUser()
                                    appState.state = .loggedIn(user)
                                } catch {
                                    print("Fail to fetch user")
                                }
                            }
                        }
                    
                }
                .tabItem { Label("Profile", systemImage: "person") }
            }
            .environmentObject(appState)
            .onOpenURL { url in
                appState.isPresentWebView = false
                Task {
                    await handleLogin(url)
                }
            }
            .fullScreenCover(isPresented: $appState.isPresentWebView) {
                if let url = authService.buildAuthorizationURL() {
                    SafariWebView(url: url)
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    func handleLogin(_ url: URL) async {
        guard let tokenResponse = await authService.handleLogin(url: url) else { return }
        do {
            print("Getting user")
            let user = try await mediaService.getUser()
            print("Got user")
            appState.state = .loggedIn(user)
            await appState.loadUserList()
            await discoverViewModel.loadMedia()
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

import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
}
