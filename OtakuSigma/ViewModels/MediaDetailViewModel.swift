//
//  MediaDetailViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation
import Combine

@MainActor
class MediaDetailViewModel<T: Media>: ObservableObject {
    @Published var selectedTab: DetailTab = .background
    @Published var isShowingAddMediaView = false
    
    @Published var progress: Double = 0 // slider only takes double (can't use media's Int progress)
    @Published var score: Double = 0    // slider only takes double
    @Published var comments: String = ""
        
    @Published var selectedStatus: SelectedStatus = .watching
//    {
//        didSet {
//            if selectedStatus == .completed && media.numEpisodesOrChapters > 0 {
//                progress = Double(media.numEpisodesOrChapters)
//            }
//        }
//    }
    
    @Published var mediaState: MediaState // this is a copy. Has no reference to appState's animeListData
    
    // Why? Cause user may need to fetch anime item (i.e. user selected recomended item) and fetching anime may fail. Having optional media is a pain in the ass, just use states
    enum MediaState {
        case loading
        case success(media: T)
        case failure(error: Error)
    }
    
    let mediaService = MALService()
    var appState: AppState
    
    var isInUserList: Bool {
        if case .success(let media) = mediaState {
            return media.myListStatus != nil
        }
        return false
    }
    
    init(media: T, userListStatus: ListStatus?, appState: AppState) {
        self.mediaState = .success(media: media)
        self.appState = appState
        
        Task {
            let fetchedMedia: T =  try await mediaService.getMediaDetail(id: media.id)
            self.mediaState = .success(media: fetchedMedia)
        }
        
        // Hit cache
        if let userListStatus {
            print("Has list status")
            if case .success(_) = mediaState {
                var updatedMedia = media
                updatedMedia.myListStatus = userListStatus
                self.mediaState = .success(media: updatedMedia)
                self.selectedStatus = SelectedStatus(rawValue: userListStatus.status)!
                self.progress = Double(userListStatus.progress)
                self.score = Double(userListStatus.score)
                self.comments = userListStatus.comments ?? ""
            }
            
        }
    }
    
    init(id: Int, appState: AppState) {
        self.mediaState = .loading
        self.appState = appState
        
        Task {
            do {
                let media: T = try await mediaService.getMediaDetail(id: id)
                print(media.relatedAnime.count)
                self.mediaState = .success(media: media)
            } catch {
                print("Error fetching media: \(error)")
                self.mediaState = .failure(error: error)
            }
            
        }
    }
    
    func didTapSaveButton() async {
        if case .success(let media) = mediaState {
            do {
                // Type checking to check wheter an instance is of a certain subclass
                if media is Anime {
                    // Update MAL user list
                    let response: AnimeUpdateResponse = try await mediaService.updateMediaListStatus(id: media.id, status: selectedStatus.rawValue, score: Int(score), progress: Int(progress), comments: comments)
                    
                    // Update detail media
                    guard var updatedAnime = media as? Anime else { return }
                    updatedAnime.myListStatus = response.listStatus
                    mediaState = .success(media: updatedAnime as! T)
                    
                    // Update home view
                    if let animeListStatus = AnimeWatchListStatus(rawValue: response.listStatus.status) {
                        guard let (status, i) = appState.getSectionAndIndex(id: media.id) as? (AnimeWatchListStatus, Int) else {
                            // Add item
                            print("Item not found, inserting item")
                            appState.userAnimeList[animeListStatus]!.insert(updatedAnime , at: 0)
                            return
                        }
                        
                        guard let oldListStatus = media.myListStatus,
                              let newListStatus = updatedAnime.myListStatus,
                              let oldStatus = AnimeWatchListStatus(rawValue: oldListStatus.status),
                              let newStatus = AnimeWatchListStatus(rawValue: newListStatus.status)
                        else { return }
                        
                        // User may have changed status
                        print("User changed section from \(oldStatus.rawValue) -> \(newStatus.rawValue)")
                        // Move item to the top
                        appState.userAnimeList[oldStatus]?.remove(at: i)
                        appState.userAnimeList[newStatus]?.insert(updatedAnime , at: 0)
                    } else if response.listStatus is MangaListStatus {
//                        guard let (status, i) = appState.getSectionAndIndex(id: media.id) as? (MangaReadListStatus, Int) else { return }
//                        appState.userMangaList[status]?[i].myListStatus = response.listStatus
                    }
                } else if media is Manga {
                    
                }
                
            } catch {
                print("Error saving list status: \(error)")
            }
        }
        
    }
    
    func didTapDeleteButton() async {
        print(#function)
        if case .success(let media) = mediaState {
            do {
                var updatedMedia = media
                updatedMedia.myListStatus = nil
                mediaState = .success(media: updatedMedia)
                
                if let _: T = try await mediaService.deleteMediaItem(id: media.id) {}
                appState.removeMedia(id: media.id)
            } catch {
                print("Error deleting item")
            }
        }
    }
    
}

