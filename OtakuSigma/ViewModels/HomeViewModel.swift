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
    @Published var appState: AppState
    
    var authService: OAuthService!  // we guarntee that this will not be nil when used. initalized it later
    let mediaService: MediaService
    
    var mediaImage: String {
        selectedMediaType == .anime ? "book" : "tv"
    }
    
    init(appState: AppState, mediaService: MediaService) {
        self.appState = appState
        self.mediaService = mediaService
        
        Task {
            await getUserAnimeList()
            await getUserMangaList()
        }
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
            userAnimeList = try await mediaService.getUserList(status: selectedAnimeStatus.rawValue, sort: AnimeSort.listUpdatedAt.rawValue, fields: Anime.fields)
        } catch {
            print("Error getting user anime list. Check if access token is valid: \(error)")
        }
    }
    
    func getUserMangaList() async {
        do {
            userMangaList = try await mediaService.getUserList(status: selectedMangaStatus.rawValue, sort: MangaSort.listUpdatedAt.rawValue, fields: Manga.fields)
        } catch {
            print("Error getting user manga list. Check if access token is valid: \(error)")
        }
    }
    
    func mediaButtonTapped() {
        selectedMediaType = selectedMediaType == .anime ? .manga : .anime
    }
}
