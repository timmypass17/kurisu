//
//  App.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation
import SwiftUI

@MainActor
class AppState: ObservableObject {
    @Published var userAnimeList: [AnimeWatchListStatus : [Anime]] = [:]
    @Published var userMangaList: [MangaReadListStatus : [Manga]] = [:]
    @Published var state: State = .unregistered
    @Published var isPresentMALLoginWebView: Bool = false
    @Published var isPresentDeleteAccountWebView: Bool = false

    var userInfo: UserInfo? {
        if case .loggedIn(let userInfo) = state {
            return userInfo
        }
        return nil
    }
    
    var mediaTask: Task<Void, Never>? = nil
    var animeMediaPage: [AnimeWatchListStatus: Int] = [:]
    var mangaMediaPage: [MangaReadListStatus: Int] = [:]
    private let limit = 100
    
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
    var discoverViewModel: DiscoverViewModel!
    let mediaService = MALService()
    let authService: OAuthService

    init(authService: OAuthService) {
        self.authService = authService
        
        Task {
            await loadUser()
        }
    }
    
    func loadUserList() async {
        await loadUserList(status: AnimeWatchListStatus.watching)
        await loadUserList(status: AnimeWatchListStatus.all)
        await loadUserList(status: AnimeWatchListStatus.completed)
        await loadUserList(status: AnimeWatchListStatus.planToWatch)
        await loadUserList(status: AnimeWatchListStatus.onHold)
        await loadUserList(status: AnimeWatchListStatus.dropped)

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
    
    func loadUser() async {
        do {
            await authService.refreshAccessTokenIfNeeded()
            guard Settings.shared.accessToken != nil else {
                print("No access token found")
                return
            }
            print("Fetching user.. Access Token:")
            let user = try await mediaService.getUser()
            print("Got User!")
            state = .loggedIn(user)
            await loadUserList()
            await discoverViewModel.loadMedia()
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

    func logOut() {
        state = .unregistered
        
        // clear data
        for (status, _) in userAnimeList {
            userAnimeList[status]?.removeAll()
            animeMediaPage[status] = 0
        }
        for (status, _) in userMangaList {
            userMangaList[status]?.removeAll()
            mangaMediaPage[status] = 0
        }
        
        // remove token
        Settings.shared.accessToken = nil
        Settings.shared.refreshToken = nil
        Settings.shared.accessTokenLastUpdated = nil
    }
    
    func loadMedia(selectedStatus: any MediaListStatus) async {
        mediaTask?.cancel()
        mediaTask = Task {
            do {
                if let selectedAnimeStatus = selectedStatus as? AnimeWatchListStatus {
                    let fetchedAnimes: [Anime] = try await mediaService.getUserList(status: homeViewModel.selectedAnimeStatus, sort: AnimeSort.listUpdatedAt, fields: Anime.fields, limit: limit, offset: animeMediaPage[selectedAnimeStatus, default: 1] * limit)
                    if !fetchedAnimes.isEmpty {
                        userAnimeList[selectedAnimeStatus]?.append(contentsOf: fetchedAnimes)
                        animeMediaPage[selectedAnimeStatus, default: 1] += 1
                    }
                } else if let selectedMangaStatus = selectedStatus as? MangaReadListStatus {
                    let fetchedMangas: [Manga] = try await mediaService.getUserList(status: selectedMangaStatus, sort: MangaSort.listUpdatedAt, fields: Manga.fields, limit: limit, offset: mangaMediaPage[selectedMangaStatus, default: 1] * limit)
                    if !fetchedMangas.isEmpty {
                        userMangaList[selectedMangaStatus]?.append(contentsOf: fetchedMangas)
                        mangaMediaPage[selectedMangaStatus, default: 1] += 1
                    }
                }
            } catch {
                print("Error loading media: \(error)")
            }
        }
    }
}
