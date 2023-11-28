//
//  AddMediaViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/21/23.
//

import Foundation

class AddMediaViewModel<T: Media>: ObservableObject {
    @Published var selectedStatus: SelectedStatus = .plan_to_watch {
        didSet {
            if selectedStatus == .completed && media.numEpisodesOrChapters > 0 {
                progress = Double(media.numEpisodesOrChapters)
            }
        }
    }
    // TODO: Use ListStatus instead of separate varaibles
    @Published var progress: Double = 0 // slider only takes double
    @Published var score: Double = 0 // slider only takes double
    @Published var comments: String = ""

    var media: T
    let mediaService = MALService()
    
    init(media: T) {
        self.media = media
        
        if let listStatus = media.myListStatus {
            self.selectedStatus = SelectedStatus(rawValue: listStatus.status)!
            self.progress = Double(listStatus.progress)
            self.score = Double(listStatus.score)
            self.comments = listStatus.comments ?? ""
        }
    }
    
    func saveButtonTapped() async -> T? {
        do {
            // Type checking to check wheter an instance is of a certain subclass
            if media is Anime {
                let response: AnimeUpdateResponse = try await mediaService.updateMediaListStatus(id: media.id, status: selectedStatus.rawValue, score: Int(score), progress: Int(progress), comments: comments)
                media.updateListStatus(status: response.status, score: response.score, progress: response.progress, comments: response.comments)
            } else {
                let response: MangaUpdateResponse = try await mediaService.updateMediaListStatus(id: media.id, status: selectedStatus.rawValue, score: Int(score), progress: Int(progress), comments: comments)
                media.updateListStatus(status: response.status, score: response.score, progress: response.progress, comments: response.comments)
            }
            
            // Return new media with updated list status
            return media
        } catch {
            print("Error saving list status: \(error)")
            return nil
        }
    }
    
}

enum SelectedStatus: String, CaseIterable, Identifiable {
    case completed, on_hold, dropped
    case watching, plan_to_watch    // anime
    case reading, plan_to_read      // manga
    var id: Self { self }
}
