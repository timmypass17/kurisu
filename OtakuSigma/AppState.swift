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
    
    var homeViewModel: HomeViewModel!
    
    init() {
        Task {
            await loadUser()
            await loadUserAnimeList(status: .all)
            await loadUserAnimeList(status: .watching)
            await loadUserAnimeList(status: .completed)
            await loadUserAnimeList(status: .planToWatch)
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
            print("Fetching user.. Access Token:")
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
            if animeStatus == .all { continue }
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
    
    func addMedia(media: Media, myListStatus: ListStatus) {
        if let anime = media as? Anime,
           let myAnimeListStatus = myListStatus as? AnimeListStatus {
            // Delete old item (if it exists)
            if let (oldStatus, i) = getSectionAndIndex(id: media.id) as? (AnimeWatchListStatus, Int) {
                print("User changed section from \(oldStatus.rawValue) -> \(myAnimeListStatus.status)")
                userAnimeList[oldStatus]?.remove(at: i)
            }
            
            // Insert new item to top
            userAnimeList[AnimeWatchListStatus(rawValue: myAnimeListStatus.status)!]?.insert(anime, at: 0)
            
            // Delete old item in 'all' (if it exists)
            if let i = userAnimeList[.all]?.firstIndex(where: { $0.id == media.id }) {
                userAnimeList[.all]?.remove(at: i)
            }
            // Insert new item to top of 'all'
            userAnimeList[.all]?.insert(anime, at: 0)
        }
    }
    
    func removeMedia(id: Int) {
        // Remove from 'all' if necessary
        if let i = userAnimeList[.all]?.firstIndex(where: { $0.id == id }) {
            userAnimeList[.all]?.remove(at: i)
        }
        
        // Look through each section to find item
        for (animeStatus, animes) in userAnimeList {
            if let index = animes.firstIndex(where: { $0.id == id }) {
                print("Found anime to delete in \(animeStatus.rawValue)")
                userAnimeList[animeStatus]?.remove(at: index)
                return
            }
        }
        
        for (mangaStatus, mangas) in userMangaList {
            if let index = mangas.firstIndex(where: { $0.id == id }) {
                print("Found manga to delete")
                userMangaList[mangaStatus]?.remove(at: index)
                return
            }
        }
        
        print("Did not find item to delete")
    }

}
