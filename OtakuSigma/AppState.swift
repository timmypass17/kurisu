//
//  App.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation
import SwiftUI

// Contains app-level information (i.e. user info)
@MainActor
class AppState: ObservableObject {
    var state: State = .unregistered
    
    @Published var userAnimeList: [AnimeWatchListStatus : [Anime]] = [:]
    @Published var userMangaList: [MangaReadListStatus : [Manga]] = [:]

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
            await loadUserAnimeList(status: .watching)
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
    
    func loadUserAnimeList(status: AnimeWatchListStatus) async {
        guard userAnimeList[status, default: []].isEmpty else { return }
        print(status.rawValue)
        do {
            let mediaService = MALService()
            userAnimeList[status] = try await mediaService.getUserList(status: status, sort: AnimeSort.listUpdatedAt)
            print(userAnimeList[status]?.count)
        } catch {
            userAnimeList[status] = []
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
    
    // Returns section and index of item (ex. "watching", 2 or "reading", 5)
    func getSectionAndIndex(id: Int) -> (any MediaListStatus, Int)? {
        for (animeStatus, animes) in userAnimeList {
            if let index = animes.firstIndex(where: { $0.id == id }) {
                return (animeStatus, index)
            }
        }
        
        for (mangaStatus, mangas) in userMangaList {
            if let index = mangas.firstIndex(where: { $0.id == id }) {
                return (mangaStatus, index)
            }
        }
        return nil
    }
    
    // Update media's status. Does nothing if media not in user's list
    func updateListStatus(id: Int, listStatus: ListStatus) {
        if listStatus is AnimeListStatus {
            guard let (status, i) = getSectionAndIndex(id: id) as? (AnimeWatchListStatus, Int) else { return }
            userAnimeList[status]?[i].myListStatus = listStatus
        } else if listStatus is MangaListStatus {
            guard let (status, i) = getSectionAndIndex(id: id) as? (MangaReadListStatus, Int) else { return }
            userMangaList[status]?[i].myListStatus = listStatus
        }
        
    }
    
//    func insert<T: Media>(media: T, to status: any MediaListStatus, at index: Int) {
//        if let anime = media as? Anime, let status = status as? AnimeWatchListStatus {
//            userAnimeList[status]?.insert(anime, at: index)
//        } else if let manga = media as? Manga, let status = status as? MangaReadListStatus {
//            userMangaList[status]?.insert(manga, at: index)
//        }
//    }

}
