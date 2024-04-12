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

class AnimeListStatus: ListStatus, ObservableObject {
    var status: String
    var score: Int
    @Published var numEpisodesWatched: Int
    var progress: Int {
        get { return numEpisodesWatched }
        set { numEpisodesWatched = newValue }
    }
    var comments: String?  // not available when getting list
    
    init(status: String, score: Int, numEpisodesWatched: Int, comments: String? = nil) {
        self.status = status
        self.score = score
        self.numEpisodesWatched = numEpisodesWatched
        self.comments = comments
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        score = try values.decode(Int.self, forKey: .score)
        numEpisodesWatched = try values.decode(Int.self, forKey: .numEpisodesWatched)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(status, forKey: .status)
        try values.encode(score, forKey: .score)
        try values.encode(numEpisodesWatched, forKey: .numEpisodesWatched)
        try values.encode(comments, forKey: .comments)
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numEpisodesWatched = "num_episodes_watched"    // this is fucking different on doc
        case comments
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/animelist"
}

class MangaListStatus: ListStatus {
    var status: String
    var score: Int
    var numChaptersRead: Int
    var progress: Int  {
        get { return numChaptersRead }
        set { numChaptersRead = newValue }
    }
    var comments: String?
    
    init(status: String, score: Int, numChaptersRead: Int, comments: String? = nil) {
        self.status = status
        self.score = score
        self.numChaptersRead = numChaptersRead
        self.comments = comments
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numChaptersRead = "num_chapters_read"
        case comments
    }
    
    static var baseURL = "https://api.myanimelist.net/v2/users/@me/mangalist"
}
