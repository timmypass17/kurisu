//
//  MediaStatus.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/9/24.
//

import Foundation

protocol MediaListStatus: CaseIterable, Identifiable, Hashable {
    static var tabItems: [Self] { get }
    var key: String { get }
    var id: Self { get }
    
}

extension MediaListStatus {
    var id: Self { self }   // default impl
}

enum AnimeWatchListStatus: String, MediaListStatus {
    case all
    case watching
    case completed
    case dropped
    case onHold = "on_hold"
    case planToWatch = "plan_to_watch"
    
    static var tabItems: [AnimeWatchListStatus] = [.all, .watching, .completed, .planToWatch]
    var key: String { self.rawValue }
}

enum MangaReadListStatus: String, MediaListStatus {
    case all
    case reading
    case completed
    case dropped
    case onHold = "on_hold"
    case planToRead = "plan_to_read"
    
    static var tabItems: [MangaReadListStatus] = [.all, .reading, .completed, .planToRead]
    var key: String { self.rawValue }
}
