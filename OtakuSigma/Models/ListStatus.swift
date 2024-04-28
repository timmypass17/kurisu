//
//  ListStatus.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import Foundation

protocol ListStatusConfiguration {
    static var baseURL: String { get }
    var postBaseURL: String { get }
    var progressKey: String { get }
}

protocol ListStatus: Codable, ListStatusConfiguration {
    var status: String { get set }
    var score: Int { get set }
    var progress: Int { get set }
    var comments: String? { get set }
    var updatedAt: String? { get }
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
    var updatedAt: String?
    
    init(status: String, score: Int, numEpisodesWatched: Int, comments: String? = nil, updatedAt: String? = nil) {
        self.status = status
        self.score = score
        self.numEpisodesWatched = numEpisodesWatched
        self.comments = comments
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numEpisodesWatched = "num_episodes_watched"    // this is fucking different on doc
        case comments
        case updatedAt = "updated_at"
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/animelist"
    var postBaseURL = "https://api.myanimelist.net/v2/anime"
    var progressKey: String = "num_watched_episodes"
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
    var updatedAt: String?
    
    init(status: String, score: Int, numChaptersRead: Int, comments: String? = nil, updatedAt: String? = nil) {
        self.status = status
        self.score = score
        self.numChaptersRead = numChaptersRead
        self.comments = comments
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numChaptersRead = "num_chapters_read"
        case comments
        case updatedAt = "updated_at"
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/mangalist"
    var postBaseURL = "https://api.myanimelist.net/v2/manga"
    var progressKey: String = "num_chapters_read"
}
