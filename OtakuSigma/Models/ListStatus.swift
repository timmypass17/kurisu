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
    var status: String { get }
    var score: Int { get }
    var progress: Int { get }
    var updatedAt: String { get }
}

struct AnimeListStatus: ListStatus {
    var status: String
    var score: Int
    var numEpisodesWatched: Int
    var updatedAt: String
    var progress: Int { numEpisodesWatched }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numEpisodesWatched = "num_episodes_watched"    // this is fucking different on doc
        case updatedAt = "updated_at"
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/animelist"
}

struct MangaListStatus: ListStatus {
    var status: String
    var score: Int
    var numChaptersRead: Int
    var updatedAt: String
    var progress: Int { numChaptersRead }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numChaptersRead = "num_chapters_read"
        case updatedAt = "updated_at"
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/mangalist"
}
