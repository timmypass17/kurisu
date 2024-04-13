//
//  App.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation
import SwiftUI

// Contains app-level information (i.e. user info)
class AppState: ObservableObject {
    var state: State = .unregistered
    
    @Published var userAnimeList: [AnimeWatchListStatus : [Anime]] = [:]

    var isLoggedIn: Bool {
        if case .loggedIn(_) = state { return true }
        return false
    }
    
    enum State {
        case unregistered
        case loggedIn(User)
        case sessionExpired(User)
    }
    
    init() {
        Task {
            await loadUser()
            await loadUserAnimeList()
        }
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
//            print("App State Progress: \(userAnimeList[.watching]?[0].myListStatus?.progress)")
//        }
    }
    
    func loadUser() async {
        do {
            guard let accessToken = Settings.shared.accessToken else { 
                print("No access token found")
                return
            }
            let mediaService = MALService()
            print("Fetching user.. Access Token: \(accessToken)")
            let user = try await mediaService.getUser(accessToken: accessToken)
            print("Got User!")
            state = .loggedIn(user)
        } catch {
            print("[ProfileViewModel] Error fetching user: \(error)")
        }
    }
    
    func loadUserAnimeList() async {
        guard userAnimeList[.watching, default: []].isEmpty else { return }
        print(#function)
        do {
            let mediaService = MALService()
            userAnimeList[.watching] = try await mediaService.getUserList(status: AnimeWatchListStatus.watching, sort: AnimeSort.listUpdatedAt, fields: Anime.fields)
        } catch {
            userAnimeList[.watching] = []
            print("Error getting user anime list. Check if access token is valid: \(error)")
        }
    }
    
//    func loadUserMangaList() async {
//        guard userMangaList[selectedMangaStatus, default: []].isEmpty else { return }
//        print(#function)
//        do {
//            userMangaList[selectedMangaStatus] = try await mediaService.getUserList(status: selectedMangaStatus, sort: MangaSort.listUpdatedAt, fields: Manga.fields)
//        } catch {
//            userMangaList[selectedMangaStatus] = []
//            print("Error getting user manga list. Check if access token is valid: \(error)")
//        }
//    }
    
    func getListStatus(for id: Int) -> ListStatus? {
        for (_, animes) in userAnimeList {
            if let anime = animes.first(where: { $0.id == id }) {
                return anime.myListStatus
            }
        }
//
//        for (_, mangas) in userMangaList {
//            if let manga = mangas.first(where: { $0.id == id }) {
//                return manga.myListStatus
//            }
//        }
//
        return nil
    }
    
    func getMediaItem(id: Int) -> (Media, any MediaListStatus, Int)? {
        for (animeStatus, animes) in userAnimeList {
            if let index = animes.firstIndex(where: { $0.id == id }) {
                return (animes[index], animeStatus, index)
            }
        }
        
        return nil
    }
}
