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
        case loggedIn(UserInfo)
        case sessionExpired(UserInfo)
    }
    
    var homeViewModel: HomeViewModel!
    let mediaService = MALService()

    init() {
        Task {
            await loadUser()
            
            await loadUserList(status: AnimeWatchListStatus.watching)
            await loadUserList(status: AnimeWatchListStatus.all)
            await loadUserList(status: AnimeWatchListStatus.completed)
            await loadUserList(status: AnimeWatchListStatus.planToWatch)

//            await loadUserList(status: MangaReadListStatus.all) // all doesn't work with manga, maybe just add the results of the previous
            await loadUserList(status: MangaReadListStatus.reading)
            await loadUserList(status: MangaReadListStatus.completed)
            await loadUserList(status: MangaReadListStatus.planToRead)
            await loadUserList(status: MangaReadListStatus.onHold)
            
            userMangaList[.all] = userMangaList[.reading, default: []] + userMangaList[.completed, default: []] + userMangaList[.planToRead, default: []] + userMangaList[.onHold, default: []]
            
            // Sort by most recent
            userMangaList[.all]?.sort { mangaA, mangaB in
                let formatter = ISO8601DateFormatter()
                guard let dateStringA = mangaA.myMangaListStatus?.updatedAt,
                      let dateStringB = mangaB.myMangaListStatus?.updatedAt,
                      let dateA = formatter.date(from: dateStringA),
                      let dateB = formatter.date(from: dateStringB)
                else { return false }
                
                return dateA > dateB
            }
        }
    }
    
    func loadUser() async {
        do {
            guard let accessToken = Settings.shared.accessToken else { 
                print("No access token found")
                return
            }
            print("Fetching user.. Access Token:")
            let user = try await mediaService.getUser()
            print("Got User!")
            state = .loggedIn(user)
        } catch {
            print("[ProfileViewModel] Error fetching user: \(error)")
        }
    }

    func loadUserList(status: any MediaListStatus) async {
        if let animeWatchListStatus = status as? AnimeWatchListStatus {
            guard userAnimeList[animeWatchListStatus, default: []].isEmpty else { return }

            do {
                userAnimeList[animeWatchListStatus] = try await mediaService.getUserList(status: status, sort: AnimeSort.listUpdatedAt)
            } catch {
                userAnimeList[animeWatchListStatus] = []
                print("Error getting user anime list. Check if access token is valid: \(error)")
            }
        } else if let mangaWatchListStatus = status as? MangaReadListStatus {
            guard userMangaList[mangaWatchListStatus, default: []].isEmpty else { return }

            do {
                userMangaList[mangaWatchListStatus] = try await mediaService.getUserList(status: status, sort: MangaSort.listUpdatedAt)
            } catch {
                userMangaList[mangaWatchListStatus] = []
                print("Error getting user anime list. Check if access token is valid: \(error)")
            }
        }
    }

    func getListStatus(for id: Int) -> ListStatus? {
        for (_, animes) in userAnimeList {
            if let anime = animes.first(where: { $0.id == id }) {
                return anime.myListStatus
            }
        }

        for (_, mangas) in userMangaList {
            if let manga = mangas.first(where: { $0.id == id }) {
                return manga.myListStatus
            }
        }

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
        } else if let manga = media as? Manga,
                  let myMangaListStatus = myListStatus as? MangaListStatus {
            // Delete old item (if it exists)
            if let (oldStatus, i) = getSectionAndIndex(id: media.id) as? (MangaReadListStatus, Int) {
                print("User changed section from \(oldStatus.rawValue) -> \(myMangaListStatus.status)")
                userMangaList[oldStatus]?.remove(at: i)
            }
            
            userMangaList[MangaReadListStatus(rawValue: myMangaListStatus.status)!]?.insert(manga, at: 0)
            
            if let i = userMangaList[.all]?.firstIndex(where: { $0.id == media.id }) {
                userMangaList[.all]?.remove(at: i)
            }
            // Insert new item to top of 'all'
            userMangaList[.all]?.insert(manga, at: 0)
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
