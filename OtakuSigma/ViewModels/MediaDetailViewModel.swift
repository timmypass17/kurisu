//
//  MediaDetailViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation
import Combine
import UIKit

protocol SelectedStatus: Identifiable {
    var id: Self { get }
    var value: String { get }
}

enum SelectedAnimeStatus: String, SelectedStatus {
    case watching, completed, plan_to_watch, on_hold, dropped
    
    var id: Self { self }
    var value: String { self.rawValue }
}

enum SelectedMangaStatus: String, SelectedStatus {
    case reading, completed, plan_to_read, on_hold, dropped
    
    var id: Self { self }
    var value: String { self.rawValue }
}

//enum SelectedStatus: String, CaseIterable, Identifiable {
//    case completed, on_hold, dropped
//    case watching, plan_to_watch    // anime
//    case reading, plan_to_read      // manga
//    var id: Self { self }
//}

@MainActor
class MediaDetailViewModel<T: Media>: ObservableObject {
    @Published var selectedTab: DetailTab = .background
    @Published var isShowingAddMediaView = false
    
    @Published var progress: Double = 0 // slider only takes double (can't use media's Int progress)
    @Published var score: Double = 0    // slider only takes double
    @Published var comments: String = ""
        
    @Published var selectedStatus: any SelectedStatus = T.self is Anime ? SelectedAnimeStatus.watching : SelectedMangaStatus.reading
    {
        didSet {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
//            if selectedStatus == .completed && media.numEpisodesOrChapters > 0 {
//                progress = Double(media.numEpisodesOrChapters)
//            }
        }
    }
    
    @Published var mediaState: MediaState // this is a copy. Has no reference to appState's animeListData
    @Published var isShowingConfirmationDialog = false
    
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
                if updatedMedia is Anime {
                    self.selectedStatus = SelectedAnimeStatus(rawValue: userListStatus.status)!
                } else {
                    self.selectedStatus = SelectedMangaStatus(rawValue: userListStatus.status)!
                }

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
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if case .success(let media) = mediaState {
            do {
                // Type checking to check wheter an instance is of a certain subclass
                if var anime = media as? Anime {
                    // Update detail media
                    let listStatus = AnimeListStatus(status: selectedStatus.value, score: Int(score), numEpisodesWatched: Int(progress), comments: comments)
                    anime.myListStatus = listStatus
                    mediaState = .success(media: anime as! T)
                    appState.addMedia(media: anime, myListStatus: listStatus)

                    // Update MAL user list
                    try await mediaService.updateMediaListStatus(id: media.id, listStatus: listStatus)
                    
                } else if var manga = media as? Manga {
                    let listStatus = MangaListStatus(status: selectedStatus.value, score: Int(score), numChaptersRead: Int(progress), comments: comments)
                    manga.myListStatus = listStatus
                    mediaState = .success(media: manga as! T)
                    appState.addMedia(media: manga, myListStatus: listStatus)
                    
                    // Update MAL user list
                    try await mediaService.updateMediaListStatus(id: media.id, listStatus: listStatus)
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

