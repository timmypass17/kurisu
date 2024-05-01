//
//  User.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation

struct UserInfo: Decodable {
    var id: Int
    var name: String
    var joinedAt: String
    var animeStatistics: AnimeStatistics
    
    var joinedAtDateFormatted: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: joinedAt) {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
        
        return ""
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name
        case joinedAt = "joined_at"
        case animeStatistics = "anime_statistics"
    }
}

struct AnimeStatistics: Decodable {
    var numItemsWatching: Int
    var numItemsCompleted: Int
    var numItemsOnHold: Int
    var numItemsDropped: Int
    var numItemsPlanToWatch: Int
    var numItems: Int   // dont use
    
    var numDaysWatched: Float
    var numDaysWatching: Float
    var numDaysCompleted: Float
    var numDaysOnHold: Float
    var numDaysDropped: Float
    var numDays: Float
    var numEpisodes: Int
    var numTimesRewatched: Int
    
    var meanScore: Float
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case numItemsWatching = "num_items_watching"
        case numItemsCompleted = "num_items_completed"
        case numItemsOnHold = "num_items_on_hold"
        case numItemsDropped = "num_items_dropped"
        case numItemsPlanToWatch = "num_items_plan_to_watch"
        case numItems = "num_items"
        case numDaysWatched = "num_days_watched"
        case numDaysWatching = "num_days_watching"
        case numDaysCompleted = "num_days_completed"
        case numDaysOnHold = "num_days_on_hold"
        case numDaysDropped = "num_days_dropped"
        case numDays = "num_days"
        case numEpisodes = "num_episodes"
        case numTimesRewatched = "num_times_rewatched"
        case meanScore = "mean_score"
    }
}

extension UserInfo {
    static let fields = CodingKeys.allCases.map { $0.rawValue }
    
    static let sampleUser = UserInfo(id: 0, name: "", joinedAt: "", animeStatistics: AnimeStatistics(numItemsWatching: 0, numItemsCompleted: 0, numItemsOnHold: 0, numItemsDropped: 0, numItemsPlanToWatch: 0, numItems: 0, numDaysWatched: 0, numDaysWatching: 0, numDaysCompleted: 0, numDaysOnHold: 0, numDaysDropped: 0, numDays: 0, numEpisodes: 0, numTimesRewatched: 0, meanScore: 0)
    )
}
