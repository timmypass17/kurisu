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
    var numEpisodesOrChapters: Int { numChapters }
    var numChapters: Int
    var mainPicture: MainPicture
    var genres: [Genre]
    var status: String
    var startSeason: StartSeason?
    var startDate: String?
    var endDate: String?
    var synopsis: String
}

extension Manga: Decodable {
    static var baseURL: String { "https://api.myanimelist.net/v2/manga" }
    static var numEpisodesOrChaptersKey: String { CodingKeys.numChapters.rawValue }
    static var fields: [String] { CodingKeys.allCases.map { $0.rawValue } + [numEpisodesOrChaptersKey] }
    static var episodeOrChaptersString: String { "Chapters" }

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
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
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
