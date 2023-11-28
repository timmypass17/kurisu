//
//  HomeViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation
import UIKit

@MainActor
class HomeViewModel: ObservableObject {
    // TODO: Maybe move collection to tabview level (higher level) and inject array into viewmodel so that when user modifies array (like adding a new anime), the changes will be reflected in here aswell.
    @Published var userAnimeList: [Anime] = []
    @Published var userMangaList: [Manga] = []
    @Published var filteredText = ""
    @Published var selectedMediaType: MediaType = .anime
    @Published var selectedAnimeStatus: AnimeStatus = .watching
    @Published var selectedMangaStatus: MangaStatus = .reading
    @Published var filteredUserAnimeList: [Anime] = []
    @Published var filteredUserMangaList: [Manga] = []

    var authService: OAuthService
    let mediaService: MediaService
    
    var mediaImage: String {
        selectedMediaType == .anime ? "book" : "tv"
    }
    
    init(authService: OAuthService, mediaService: MediaService) {
        self.authService = authService
        self.mediaService = mediaService
        
        Task {
            if authService.isLoggedIn {
                print("user is logged in")
                await getUserAnimeList()
                await getUserMangaList()
                print(userAnimeList)
            } else {
                print("user is not logged in")
            }
        }
//        Task {
//            guard let tokenLastUpdated = Settings.shared.accessTokenLastUpdated else { return }
//
//            print("User has access token")
//            // Check if access token expired
//            let tokenExpirationDate = tokenLastUpdated.addingTimeInterval(Settings.accessTokenDurationInSeconds)
//            let isTokenExpired = tokenExpirationDate < .now
//            if isTokenExpired {
//                print("Token Expired... refresing access token")
//                await authService.refreshAccessToken()
//            }
//
//            print("Initalizing user data")
//            // Initalize user's data
//            await getUserAnimeList()
//            await getUserMangaList()
//        }
    }
    
    func filterTextValueChanged() {
        if selectedMediaType == .anime {
            filteredUserAnimeList = userAnimeList.filter { $0.title.lowercased().contains(filteredText.lowercased()) }
        } else {
            filteredUserMangaList = userMangaList.filter { $0.title.lowercased().contains(filteredText.lowercased()) }
        }
    }
    
    func getUserAnimeList() async {
        print("getUserAnimeList()")
        do {
            userAnimeList = try await mediaService.getUserList(status: selectedAnimeStatus.rawValue, sort: AnimeSort.animeTitle.rawValue)
        } catch {
            print("Error getting user anime list. Check if access token is valid: \(error)")
        }
    }
    
    func getUserMangaList() async {
        do {
            userMangaList = try await mediaService.getUserList(status: selectedMangaStatus.rawValue, sort: MangaSort.mangaTitle.rawValue)
        } catch {
            print("Error getting user manga list. Check if access token is valid: \(error)")
        }
    }
    
    func authorizeButtonTapped() {
        guard let authorizationURL = authService.buildAuthorizationURL() else { return }
        UIApplication.shared.open(authorizationURL)
    }
    
    // Returns true if user authorizes app
    func generateAccessToken(from url: URL) async {
        guard let codeVerifier = authService.codeVerifier else { return }
        authService.isLoggedIn = await authService.generateAccessToken(from: url, codeVerifier: codeVerifier)
        if authService.isLoggedIn {
            // Load user list
            await getUserAnimeList()
        }
    }
    
    func mediaButtonTapped() {
        selectedMediaType = selectedMediaType == .anime ? .manga : .anime
        print(selectedMediaType.rawValue)
    }
}
