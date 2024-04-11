//
//  MediaDetailViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation

@MainActor
class MediaDetailViewModel<T: Media>: ObservableObject {
    @Published var selectedTab: DetailTab = .background
    @Published var isShowingAddMediaView = false
    
    var media: T
    var userListStatus: ListStatus?

    init(media: T, userListStatus: ListStatus?) {
        self.media = media
        self.userListStatus = userListStatus
        if userListStatus != nil {
            print("Has list status")
            self.media.myListStatus = userListStatus
        } else {
            print("No list status")
            // TODO: Fetch user's list status
        }
    }
}

