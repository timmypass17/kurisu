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
    @Published var selectedAnimeStatus: AnimeStatus = .watching {
        didSet { Task { await loadUserAnimeList() } }
    }
    @Published var selectedMangaStatus: MangaStatus = .reading {
        didSet { Task { await loadUserMangaList() } }
    }
    @Published var selectedMediaType: MediaType = .anime {
        didSet {
            if selectedMediaType == .anime {
                Task { await loadUserAnimeList() }
            } else {
                Task { await loadUserMangaList() }
            }
        }
    }
    @Published var filteredText = "" {
        didSet { filterTextValueChanged() }
    }
    @Published var filteredUserAnimeList: [Anime] = []
    @Published var filteredUserMangaList: [Manga] = []
    @Published var appState: AppState = AppState.shared
    
    var authService: OAuthService  // we guarntee that this will not be nil when used. initalized it later
    let mediaService: MediaService
    
    var mediaImage: String {
        selectedMediaType == .anime ? "book" : "tv"
    }
    
    init(mediaService: MediaService, authService: OAuthService) {
        self.mediaService = mediaService
        self.authService = authService
        
        Task {
            await loadUserAnimeList()
        }
    }
    
    private func filterTextValueChanged() {
        if selectedMediaType == .anime {
            filteredUserAnimeList = userAnimeList.filter { $0.title.lowercased().contains(filteredText.lowercased()) }
        } else {
            filteredUserMangaList = userMangaList.filter { $0.title.lowercased().contains(filteredText.lowercased()) }
        }
    }
    
    func loadUserAnimeList() async {
        do {
            userAnimeList = try await mediaService.getUserList(status: selectedAnimeStatus, sort: AnimeSort.listUpdatedAt, fields: Anime.fields)
        } catch {
            print("Error getting user anime list. Check if access token is valid: \(error)")
        }
    }
    
    func loadUserMangaList() async {
        do {
            userMangaList = try await mediaService.getUserList(status: selectedMangaStatus, sort: MangaSort.listUpdatedAt, fields: Manga.fields)
        } catch {
            print("Error getting user manga list. Check if access token is valid: \(error)")
        }
    }
    
    func didTapMediaButton() {
        selectedMediaType = selectedMediaType == .anime ? .manga : .anime
    }
    
    func didTapLoginButton() {
        authService.showLogin()
    }
    
}
