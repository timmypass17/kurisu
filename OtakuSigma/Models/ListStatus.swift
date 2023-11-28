//
//  ListStatus.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation

protocol ListStatusConfiguration {
    static var baseURL: String { get }
}
protocol ListStatus: Codable, ListStatusConfiguration {
    var status: String { get set }
    var score: Int { get set }
    var progress: Int { get set }
    var comments: String? { get set }
}

struct AnimeListStatus: ListStatus {
    var status: String
    var score: Int
    var numEpisodesWatched: Int
    var progress: Int {
        get { return numEpisodesWatched }
        set { numEpisodesWatched = newValue }
    }
    var comments: String?  // not available when getting list
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numEpisodesWatched = "num_episodes_watched"    // this is fucking different on doc
        case comments
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/animelist"
}

struct MangaListStatus: ListStatus {
    var status: String
    var score: Int
    var numChaptersRead: Int
    var progress: Int  {
        get { return numChaptersRead }
        set { numChaptersRead = newValue }
    }
    var comments: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numChaptersRead = "num_chapters_read"
        case comments
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/mangalist"
}
