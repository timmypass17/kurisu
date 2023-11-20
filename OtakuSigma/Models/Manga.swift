//
//  Manga.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
struct Manga: Media {
    var id: Int
    var title: String
    var alternativeTitles: AlternativeTitles
    var numEpisodesOrChapters: Int { numChapters }
    var numChapters: Int
    var mainPicture: MainPicture
    var genres: [Genre]
    var status: String
    var startSeason: StartSeason?
    var startDate: String?
    var endDate: String?
    var synopsis: String
    var myListStatus: ListStatus? { nil }
    var numVolumes: Int
    var minutesOrVolumes: Int { numVolumes }
    var mean: Float?
    var rank: Int?
    var popularity: Int
    var numListUsers: Int
    var relatedAnime: [RelatedItem]
    var relatedManga: [RelatedItem]
    var mediaType: String
    var recommendations: [RecommendedItem]
    var authors: [Author]
}

// Note: Decode for reading data. Encode for encoding (convert data to form that can be saved) saving data. Codable for both
struct Author: Codable {
    var node: AuthorNode
    var role: String
}

struct AuthorNode: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

extension Manga: Decodable {
    static var baseURL: String { "https://api.myanimelist.net/v2/manga" }
    static var numEpisodesOrChaptersKey: String { CodingKeys.numChapters.rawValue }
    static var fields: [String] { CodingKeys.allCases.map { $0.rawValue } + [numEpisodesOrChaptersKey, ",authors{first_name,last_name}"] }
    static var episodeOrChaptersString: String { "Chapters" }
    static var minutesOrVolumesString: String { "Volumes" }
    static var relatedItemString: String { "Related Mangas" }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case title
        case numChapters = "num_chapters"
        case mainPicture = "main_picture"
        case genres
        case status
        case startSeason = "start_season"
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis
        case numVolumes = "num_volumes"
        case mean
        case rank
        case popularity
        case numListUsers = "num_list_users"
        case alternativeTitles = "alternative_titles"
        case relatedAnime = "related_anime"
        case relatedManga = "related_manga"
        case mediaType = "media_type"
        case recommendations
        case authors
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        alternativeTitles = try values.decode(AlternativeTitles.self, forKey: .alternativeTitles)
        numChapters = try values.decode(Int.self, forKey: .numChapters)
        mainPicture = try values.decode(MainPicture.self, forKey: .mainPicture)
        genres = try values.decode([Genre].self, forKey: .genres)
        status = try values.decode(String.self, forKey: .status).snakeToRegularCase()
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        
        // Manga have no "season" but we can derive from startDate
        if let startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            if let date = dateFormatter.date(from: startDate) {
                let year = Calendar.current.component(.year, from: date)
                let season = date.season.rawValue
                startSeason = StartSeason(year: year, season: season)
            }
        }
        synopsis = try values.decode(String.self, forKey: .synopsis)
        numVolumes = try values.decode(Int.self, forKey: .numVolumes)
        mean = try values.decode(Float.self, forKey: .mean)
        rank = try values.decode(Int.self, forKey: .rank)
        popularity = try values.decode(Int.self, forKey: .popularity)
        numListUsers = try values.decode(Int.self, forKey: .numListUsers)
        relatedAnime = try values.decodeIfPresent([RelatedItem].self, forKey: .relatedAnime) ?? []  // could be missing, add default value instead of nil
        relatedManga = try values.decodeIfPresent([RelatedItem].self, forKey: .relatedManga) ?? []
        mediaType = try values.decode(String.self, forKey: .mediaType)
        recommendations = try values.decodeIfPresent([RecommendedItem].self, forKey: .recommendations) ?? []
        authors = try values.decode([Author].self, forKey: .authors)
    }
}

extension Date {
    var season: Season {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        
        let month = components.month!
        
        switch month {
        case 12, 1, 2:
            return .winter
        case 3...5:
            return .spring
        case 6...8:
            return .summer
        default:
            return .fall
        }
    }
}
