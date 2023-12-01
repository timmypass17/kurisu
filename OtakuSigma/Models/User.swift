//
//  User.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation

struct User: Decodable {
    var id: Int
    var name: String
    var joinedAt: String
    var animeStatistics: AnimeStatistics
//    var mangaStatistics: MangaStatistics

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name
        case joinedAt = "joined_at"
        case animeStatistics = "anime_statistics"
//        case mangaStatistics = "manga_statistics"
    }
}

struct AnimeStatistics: Decodable {
    var numItemsWatching: Int
    var numItemsCompleted: Int
    var numItemsOnHold: Int
    var numItemsDropped: Int
    var numItemsPlanToWatch: Int
    var numItems: Int   // dont use
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case numItemsWatching = "num_items_watching"
        case numItemsCompleted = "num_items_completed"
        case numItemsOnHold = "num_items_on_hold"
        case numItemsDropped = "num_items_dropped"
        case numItemsPlanToWatch = "num_items_plan_to_watch"
        case numItems = "num_items"
    }
    
    func toChartData() -> [BarChartItem] {
        let watching = BarChartItem(value: Double(numItemsWatching), category: "Watching")
        let completed = BarChartItem(value: Double(numItemsCompleted), category: "Completed")
        let onHold = BarChartItem(value: Double(numItemsOnHold), category: "On Hold")
        let planToWatch = BarChartItem(value: Double(numItemsDropped), category: "Plan To Watch")
        let dropped = BarChartItem(value: Double(numItemsDropped), category: "Dropped")
        
        return [watching, completed, onHold, planToWatch, dropped]
    }
}

//struct MangaStatistics: Decodable {
//    var numItemsReading: Int
//    
//    enum CodingKeys: String, CodingKey, CaseIterable {
//        case numItemsReading = "num_items_reading"
//    }
//}

extension User {
    static let fields = CodingKeys.allCases.map { $0.rawValue }
    
    static let sampleUser = User(id: 1, name: "timmypass21", joinedAt: "2017-09-11T10:27:46+00:00",
                                 animeStatistics: AnimeStatistics(numItemsWatching: 10, numItemsCompleted: 10, numItemsOnHold: 10, numItemsDropped: 10, numItemsPlanToWatch: 10, numItems: 50))
}
