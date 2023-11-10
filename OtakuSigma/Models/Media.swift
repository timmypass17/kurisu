//
//  WeebItem.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation

protocol WeebItemConfiguration {
    static var baseURL: String { get }
    static var numEpisodesOrChaptersKey: String { get }
    static var fields: [String] { get }
    static var episodeOrChaptersString: String { get }
}

// Common attributes between Anime and Mangga
protocol Media: Codable, WeebItemConfiguration {
    var id: Int { get }
    var title: String { get }
    var numEpisodesOrChapters: Int { get }
    var mainPicture: MainPicture { get }
    var genres: [Genre] { get }
    var status: String { get }
    var startSeason: StartSeason? { get }
    var startDate: String? { get }
    var endDate: String? { get }
    var synopsis: String { get }
//    var myListStatus: ListStatus? { get }
}

extension Media {
    // Default implementations
    var startSeasonFormatted: String {
        if let startSeason {
            return "\(startSeason.season.capitalized) \(startSeason.year)"
        }
        return "No Date"
    }
    
    var nextEpisodeFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return "X days"
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

let sampleAnimes: [Anime] = [
    Anime(
        id: 44511,
        title: "Chainsaw Man",
        numEpisodes: 12,
        mainPicture: MainPicture(
            medium: "https://cdn.myanimelist.net/images/anime/1806/126216.jpg",
            large: "https://cdn.myanimelist.net/images/anime/1806/126216l.jpg"),
        genres: ["Action", "Fantasy", "Gore", "Shounen"].map { Genre(name: $0) },
        status: "Finished Airing",
        startSeason: StartSeason(year: 2022, season: "fall"),
        broadcast: Broadcast(
            dayOfTheWeek: "wednesday",
            startTime: "00:00"
        ),
        synopsis: "Denji is robbed of a normal teenage life, left with nothing but his deadbeat father's overwhelming debt. His only companion is his pet, the chainsaw devil Pochita, with whom he slays devils for money that inevitably ends up in the yakuza's pockets. All Denji can do is dream of a good, simple life: one with delicious food and a beautiful girlfriend by his side. But an act of greedy betrayal by the yakuza leads to Denji's brutal, untimely death, crushing all hope of him ever achieving happiness."
    )
]

let sampleListStatus = AnimeListStatus(status: "watching", score: 8, numEpisodesWatched: 11, updatedAt: "2017-11-11T19:52:16+00:00")
let sampleUserNode = UserNode(node: sampleAnimes[0], listStatus: sampleListStatus)

extension String {
    func snakeToRegularCase() -> String {
        let components = self.components(separatedBy: "_")
        let camelCaseComponents = components.map { $0.capitalized }
        return camelCaseComponents.joined(separator: " ")
    }
}
