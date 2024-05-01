//
//  HomeViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation
import UIKit
import Combine

// @Published only works with structs (arrays/dicts are structs in swift)
@MainActor
class HomeViewModel: ObservableObject {
    @Published var selectedAnimeStatus: AnimeWatchListStatus = .watching
    @Published var selectedMangaStatus: MangaReadListStatus = .reading
    @Published var selectedMediaType: MediaType = .anime
    @Published var filteredText = "" {
        didSet { filterTextValueChanged() }
    }
    @Published var filteredUserAnimeList: [Anime] = []
    @Published var filteredUserMangaList: [Manga] = []
    
    var appState: AppState?
    var authService: OAuthService
    let mediaService: MediaService
    
    var mediaImage: String {
        selectedMediaType == .anime ? "book" : "tv"
    }
    
    var title: String {
        selectedMediaType == .anime ? "My Anime List" : "My Manga List"
    }
        
    var mediaTask: Task<Void, Never>? = nil
    var animeMediaPage: [AnimeWatchListStatus: Int] = [:]
    var mangaMediaPage: [MangaReadListStatus: Int] = [:]
    private let limit = 100
    
    init(mediaService: MediaService, authService: OAuthService) {
        self.mediaService = mediaService
        self.authService = authService
    }
    
    private func filterTextValueChanged() {
        guard let appState else { return }
        if selectedMediaType == .anime {
            if filteredText.isEmpty {
                filteredUserAnimeList = appState.userAnimeList[selectedAnimeStatus, default: []]
                return
            }
            filteredUserAnimeList = appState.userAnimeList[selectedAnimeStatus, default: []].filter { $0.title.lowercased().contains(filteredText.lowercased()) }
        } else {
            if filteredText.isEmpty { 
                filteredUserMangaList = appState.userMangaList[selectedMangaStatus, default: []]
                return
            }
            filteredUserMangaList = appState.userMangaList[selectedMangaStatus, default: []].filter { $0.title.lowercased().contains(filteredText.lowercased()) }
        }
    }
    
    func didTapMediaButton() {
        selectedMediaType = selectedMediaType == .anime ? .manga : .anime
    }
}
