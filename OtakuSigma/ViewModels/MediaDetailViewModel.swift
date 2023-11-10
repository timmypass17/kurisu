//
//  MediaDetailViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation

@MainActor
class MediaDetailViewModel<T: Media>: ObservableObject {
    @Published var state: MediaDetailState = .loading
    var listStatus: ListStatus? = nil
    var id: Int
    
    let mediaService: MediaService
//    var userCollection: UserCollection
    
    enum MediaDetailState {
        case loading
        case success(media: T)
        case failure(error: Error)
    }
    
    init(id: Int, mediaService: MediaService) {
        self.id = id
        self.mediaService = mediaService
//        self.userCollection = userCollection
        Task {
            await getMedia()
        }
    }
    
    func getMedia() async {
        // Fetch anime
        do {
            let media: T =  try await mediaService.getMediaDetail(id: id, fields: T.fields)
            print(media)
            // TODO: Get user's list of anime, save as dict using [id: ListStatus]
            if T.self == Anime.self {
                listStatus = AnimeListStatus(status: "", score: 8, numEpisodesWatched: 11, updatedAt: "")
            } else {
                listStatus = MangaListStatus(status: "", score: 8, numChaptersRead: 11, updatedAt: "")
            }
            
            state = .success(media: media)
        } catch {
            state = .failure(error: error)
            print(error)
        }
    }
}
