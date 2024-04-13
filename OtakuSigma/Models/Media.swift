//
//  WeebItem.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation
import SwiftUI

protocol WeebItemConfiguration {
    static var baseURL: String { get }
    static var userBaseURL: String{ get }
    static var numEpisodesOrChaptersKey: String { get }
    static var fields: [String] { get }
    static var episodesOrChaptersString: String { get }
    static var episodeOrChapterString: String { get }
    static var minutesOrVolumesString: String { get }
    static var relatedItemString: String { get }
}

// Common attributes between Anime and Mangga
protocol Media: Codable, WeebItemConfiguration {
    var id: Int { get }
    var title: String { get set }
    var alternativeTitles: AlternativeTitles { get }
    var numEpisodesOrChapters: Int { get }
    var mainPicture: MainPicture { get }
    var genres: [Genre] { get }
    var status: MediaStatus { get }
    var startSeason: StartSeason? { get }
    var startDate: String? { get }
    var endDate: String? { get }
    var synopsis: String { get }
    var myListStatus: ListStatus? { get set }
    var minutesOrVolumes: Int { get }
    var mean: Float? { get }
    var rank: Int? { get }
    var popularity: Int { get }
    var numListUsers: Int { get }
    var relatedAnime: [RelatedItem] { get }
    var relatedManga: [RelatedItem] { get }
    var mediaType: String { get }
    var recommendations: [RecommendedItem] { get }
    
    func episodeOrChapterString() -> String
    
//    mutating func updateListStatus(status: String, score: Int, progress: Int, comments: String?)
    
    var nextReleaseString: String { get }
    
    func changeTitle() 
}

extension Media {
    // Default implementations
    func changeTitle() {
//        title = "New Title"
    }
    
    var startSeasonString: String {
        if let startSeason {
            return "\(startSeason.season.capitalized) \(startSeason.year)"
        }
        return "No Date"
    }
    
//    var nextEpisodeFormatted: String {
//
//    }
    
    var scoreString: String {
        if let mean {
            return "\(mean)"
        }
        return "?"
    }
    
    var rankString: String {
        if let rank {
            return "\(rank)"
        }
        return "?"
    }
    
    var airedString: String {
        if let startDate, let endDate {
            return "\(airedDateFormatter(dateString: startDate)) - \(airedDateFormatter(dateString: endDate))"
        } else if let startDate {
            return "\(airedDateFormatter(dateString: startDate)) - ?"
        } else if let endDate {
            return "? - \(airedDateFormatter(dateString: endDate))"
        } else {
            return "? - ?"
        }
    }
    
    private func airedDateFormatter(dateString: String) -> String {
        // Create a DateFormatter with the input format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        // Parse the input string to a Date object
        if let date = inputFormatter.date(from: dateString) {
            // Create a DateFormatter with the desired output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyyy"

            // Convert the date to the desired output format
            let outputDateString = outputFormatter.string(from: date)

            return outputDateString
        } else {
            return "?"
        }
    }
}

struct MainPicture: Codable {
    var medium: String
    var large: String
}

struct Genre: Codable {
    var name: String
}

struct StartSeason: Codable {
    var year: Int
    var season: String
}

struct Broadcast: Codable {
    var dayOfTheWeek: String
    var startTime: String?
    
    enum CodingKeys: String, CodingKey {
        case dayOfTheWeek = "day_of_the_week"
        case startTime = "start_time"
    }
}

struct AlternativeTitles: Codable {
    var en: String
}

struct RelatedItem: Codable {
    var node: RelatedNode
    var relationTypeFormatted: String
    
    enum CodingKeys: String, CodingKey {
        case node
        case relationTypeFormatted = "relation_type_formatted"
    }
}

struct RelatedNode: Codable {
    var id: Int
    var title: String
    var mainPicture: MainPicture
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case mainPicture = "main_picture"
    }
}

struct RecommendedItem: Codable {
    var node: RelatedNode
    var numRecommendations: Int
    
    enum CodingKeys: String, CodingKey {
        case node
        case numRecommendations = "num_recommendations"
    }
}

let sampleAnimes: [Anime] = [
    Anime(
        id: 44511,
        title: "Chainsaw Man",
        alternativeTitles: AlternativeTitles(en: "Chainsaw Man"),
        numEpisodes: 12,
        mainPicture: MainPicture(
            medium: "https://cdn.myanimelist.net/images/anime/1806/126216.jpg",
            large: "https://cdn.myanimelist.net/images/anime/1806/126216l.jpg"),
        genres: ["Action", "Fantasy", "Gore", "Shounen"].map { Genre(name: $0) },
        animeStatus: .finishedAiring,
        startSeason: StartSeason(year: 2022, season: "fall"),
        broadcast: Broadcast(
            dayOfTheWeek: "wednesday",
            startTime: "00:00"
        ),
        synopsis: "Denji is robbed of a normal teenage life, left with nothing but his deadbeat father's overwhelming debt. His only companion is his pet, the chainsaw devil Pochita, with whom he slays devils for money that inevitably ends up in the yakuza's pockets. All Denji can do is dream of a good, simple life: one with delicious food and a beautiful girlfriend by his side. But an act of greedy betrayal by the yakuza leads to Denji's brutal, untimely death, crushing all hope of him ever achieving happiness.",
        averageEpisodeDuration: 1440,
        mean: 8.42,
        rank: 152,
        popularity: 1381,
        numListUsers: 189296,
        relatedAnime: [],
        relatedManga: [],
        mediaType: "tv",
        studios: [],
        source: "Manga",
        recommendations: [],
        rating: "pg",
        statistics: Statistics(status: Status(watching: "", completed: "", onHold: "", dropped: "", planToWatch: ""), numListUsers: 0)
    )
]

let sampleListStatus = AnimeListStatus(status: "watching", score: 8, numEpisodesWatched: 11, comments: "")

extension String {
    func snakeToRegularCase() -> String {
        let components = self.components(separatedBy: "_")
        let camelCaseComponents = components.map { $0.capitalized }
        return camelCaseComponents.joined(separator: " ")
    }
}
