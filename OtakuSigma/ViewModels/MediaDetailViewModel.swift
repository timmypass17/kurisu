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
        
    @Published var selectedStatus: SelectedStatus = .plan_to_watch 
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
        
        // can't update associated value of enum directly because it's just a copy, need to have mutating func and reassign new copy to update values
        // https://stackoverflow.com/questions/31488603/can-i-change-the-associated-values-of-a-enum
        mutating func updateListStatus(listStatus: ListStatus) {
            switch self {
            case .success(let media):
                var updatedMedia = media
                updatedMedia.myListStatus = listStatus
                self = .success(media: updatedMedia)
            default:
                return
            }
        }
        
        mutating func updateMediaRecs(fetchedMedia: T) {
            switch self {
            case .success(let media):
                var updatedMedia = media
                updatedMedia.relatedAnime = fetchedMedia.relatedAnime
                updatedMedia.relatedManga = fetchedMedia.relatedManga
                updatedMedia.recommendations = fetchedMedia.recommendations
                self = .success(media: updatedMedia)
            default:
                return
            }
        }
    }
    
    let mediaService = MALService()
    let appState: AppState
    
    init(media: T, userListStatus: ListStatus?, appState: AppState) {
        self.mediaState = .success(media: media)
        self.appState = appState
        
        Task {
            let fetchedMedia: T =  try await mediaService.getMediaDetail(id: media.id)
            mediaState.updateMediaRecs(fetchedMedia: fetchedMedia)
        }
        
        if let userListStatus {
            print("Has list status")
            if case .success(_) = mediaState {
                mediaState.updateListStatus(listStatus: userListStatus)
                self.selectedStatus = SelectedStatus(rawValue: userListStatus.status)!
                self.progress = Double(userListStatus.progress)
                self.score = Double(userListStatus.score)
                self.comments = userListStatus.comments ?? ""
            }
            
        } else {
            print("No list status")
            // TODO: Fetch user's list status
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
                    let mediaService = MALService()
                    let response: AnimeUpdateResponse = try await mediaService.updateMediaListStatus(id: media.id, status: selectedStatus.rawValue, score: Int(score), progress: Int(progress), comments: comments)
                    
                    // Update local media
                    mediaState.updateListStatus(listStatus: response.listStatus)

                    // Update user data (which updates homeview)
                    appState.updateListStatus(id: media.id, listStatus: response.listStatus)
                } else if media is Manga {
                    
                }
                
            } catch {
                print("Error saving list status: \(error)")
            }
        }
        
    }
}

