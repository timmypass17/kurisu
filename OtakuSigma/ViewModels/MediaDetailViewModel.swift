//
//  MediaDetailViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation
import Combine
import UIKit

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
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if case .success(let media) = mediaState {
            do {
                // Type checking to check wheter an instance is of a certain subclass
                if media is Anime {
                    // Update detail media
                    guard var updatedAnime = media as? Anime else { return }
                    let listStatus = AnimeListStatus(status: selectedStatus.rawValue, score: Int(score), numEpisodesWatched: Int(progress), comments: comments)
                    updatedAnime.myListStatus = listStatus
                    mediaState = .success(media: updatedAnime as! T)
                    appState.addMedia(media: updatedAnime, myListStatus: listStatus)

                    // Update MAL user list
                    let _: AnimeUpdateResponse = try await mediaService.updateMediaListStatus(id: media.id, listStatus: listStatus)
                    
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

