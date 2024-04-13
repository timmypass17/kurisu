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
    
    @Published var progress: Double = 0 // slider only takes double
    @Published var score: Double = 0 // slider only takes double
    @Published var comments: String = ""
        
    @Published var selectedStatus: SelectedStatus = .plan_to_watch {
        didSet {
            if selectedStatus == .completed && media.numEpisodesOrChapters > 0 {
                media.myListStatus?.progress = Int(Double(media.numEpisodesOrChapters))
            }
        }
    }
    
    @Published var media: T // this is a copy. Has no reference to appState's animeListData
    let appState: AppState
    
    init(media: T, userListStatus: ListStatus?, appState: AppState) {
        self.media = media
        self.appState = appState
        
        if let userListStatus {
            print("Has list status")
            self.media.myListStatus = userListStatus
            self.selectedStatus = SelectedStatus(rawValue: userListStatus.status)!
            self.progress = Double(userListStatus.progress)
            self.score = Double(userListStatus.score)
            self.comments = userListStatus.comments ?? ""
        } else {
            print("No list status")
            // TODO: Fetch user's list status
        }
    }
    
    func didTapSaveButton() async -> Media? {
        print(#function)
        do {
            // Type checking to check wheter an instance is of a certain subclass
            if media is Anime {
                let mediaService = MALService()
                let _: AnimeUpdateResponse = try await mediaService.updateMediaListStatus(id: media.id, status: selectedStatus.rawValue, score: Int(score), progress: Int(progress), comments: comments)

                media.myListStatus?.status = selectedStatus.rawValue
                media.myListStatus?.progress = Int(progress)
                media.myListStatus?.score = Int(score)
                media.myListStatus?.comments = comments
                
            }
            print(media.myListStatus)
            // Return new media with updated list status
            return media
        } catch {
            print("Error saving list status: \(error)")
            return nil
        }
    }
}

