//
//  Anime.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation

struct Anime: Media {
    var id: Int
    var title: String
    var alternativeTitles: AlternativeTitles
    var numEpisodesOrChapters: Int { numEpisodes }
    var numEpisodes: Int
    var mainPicture: MainPicture
    var genres: [Genre]
    var status: String
    var startSeason: StartSeason?
    var broadcast: Broadcast?
    var startDate: String?
    var endDate: String?
    var synopsis: String
    var myAnimeListStatus: AnimeListStatus?
    var myListStatus: ListStatus? { myAnimeListStatus }
    var averageEpisodeDuration: Int
    var minutesOrVolumes: Int { averageEpisodeDuration / 60 }
    var mean: Float?
    var rank: Int?
    var popularity: Int
    var numListUsers: Int
    var relatedAnime: [RelatedItem]
    var relatedManga: [RelatedItem]
    var mediaType: String
    var studios: [Studio]
    var source: String
    var recommendations: [RecommendedItem]
    var rating: String
    var statistics: Statistics

    var broadcastString: String {
        guard let startDate, let startTime = broadcast?.startTime else { return "?" }

        let combinedDateString = "\(startDate) \(startTime)"

        // Parse the combined date and time string
        let combinedDateFormatter = DateFormatter()
        combinedDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        combinedDateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")

        if let combinedDate = combinedDateFormatter.date(from: combinedDateString) {
            // Convert to the user's local time zone
            let userTimeZone = TimeZone.current
            let userDateFormatter = DateFormatter()
            userDateFormatter.dateFormat = "EEEE 'at' h:mma (zzz)"
            userDateFormatter.timeZone = userTimeZone

            let userDateString = userDateFormatter.string(from: combinedDate)
            return userDateString
        } else {
            return "?"
        }
    }
}

struct Statistics: Codable {
    var status: Status
    var numListUsers: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case numListUsers = "num_list_users"
    }
}

struct Status: Codable {
    var watching: String
    var completed: String
    var onHold: String
    var dropped: String
    var planToWatch: String
    
    enum CodingKeys: String, CodingKey {
        case watching
        case completed
        case onHold = "on_hold"
        case dropped
        case planToWatch = "plan_to_watch"
    }
    
}

struct Studio: Codable {
    var name: String
}

extension Anime: Decodable {
    static var baseURL: String { "https://api.myanimelist.net/v2/anime" }
    static var numEpisodesOrChaptersKey: String { CodingKeys.numEpisodes.rawValue }
    static var fields: [String] { CodingKeys.allCases.map { $0.rawValue } }
    static var episodeOrChaptersString: String { "Episodes" }
    static var minutesOrVolumesString: String { "Minutes" }
    static var relatedItemString: String { "Related Animes" }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case title
        case alternativeTitles = "alternative_titles"
        case numEpisodes = "num_episodes"
        case mainPicture = "main_picture"
        case genres
        case status
        case startSeason = "start_season"
        case broadcast
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis
        case myAnimeListStatus = "my_list_status"
        case averageEpisodeDuration = "average_episode_duration"
        case mean
        case rank
        case popularity
        case numListUsers = "num_list_users"
        case relatedAnime = "related_anime"
        case relatedManga = "related_manga"
        case mediaType = "media_type"
        case studios
        case source
        case recommendations
        case rating
        case statistics
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        alternativeTitles = try values.decode(AlternativeTitles.self, forKey: .alternativeTitles)
        numEpisodes = try values.decode(Int.self, forKey: .numEpisodes)
        mainPicture = try values.decode(MainPicture.self, forKey: .mainPicture)
        genres = try values.decode([Genre].self, forKey: .genres)
        status = try values.decode(String.self, forKey: .status).snakeToRegularCase()
        startSeason = try values.decodeIfPresent(StartSeason.self, forKey: .startSeason)
        broadcast = try values.decodeIfPresent(Broadcast.self, forKey: .broadcast)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        synopsis = try values.decode(String.self, forKey: .synopsis)
        myAnimeListStatus = try values.decodeIfPresent(AnimeListStatus.self, forKey: .myAnimeListStatus)
        averageEpisodeDuration = try values.decode(Int.self, forKey: .averageEpisodeDuration)
        mean = try values.decodeIfPresent(Float.self, forKey: .mean)
        rank = try values.decodeIfPresent(Int.self, forKey: .rank)
        popularity = try values.decode(Int.self, forKey: .popularity)
        numListUsers = try values.decode(Int.self, forKey: .numListUsers)
        relatedAnime = try values.decodeIfPresent([RelatedItem].self, forKey: .relatedAnime) ?? []  // could be missing, add default value instead of nil
        relatedManga = try values.decodeIfPresent([RelatedItem].self, forKey: .relatedManga) ?? []
        mediaType = try values.decode(String.self, forKey: .mediaType)
        studios = try values.decode([Studio].self, forKey: .studios)
        source = try values.decode(String.self, forKey: .source)
        recommendations = try values.decodeIfPresent([RecommendedItem].self, forKey: .recommendations) ?? []
        rating = (try values.decodeIfPresent(String.self, forKey: .rating) ?? "?").uppercased().replacingOccurrences(of: "_", with: " ")
        statistics = (try values.decodeIfPresent(Statistics.self, forKey: .statistics)) ?? Statistics(status: Status(watching: "0", completed: "0", onHold: "0", dropped: "0", planToWatch: "0"), numListUsers: 0)
    }
}
