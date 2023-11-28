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
    @Published var selectedTab: DetailTab = .background
    @Published var isShowingAddMediaView = false
    
    var id: Int
    
    let mediaService: MediaService
    
    enum MediaDetailState {
        case loading
        case success(media: T)
        case failure(error: Error)
    }

    init(id: Int, mediaService: MediaService) {
        self.id = id
        self.mediaService = mediaService
        Task {
            await getMedia()
        }
    }
    
    func getMedia() async {
        // Fetch anime
        do {
            let media: T =  try await mediaService.getMediaDetail(id: id, fields: T.fields)
            state = .success(media: media)
        } catch {
            state = .failure(error: error)
        }
    }
    

}

