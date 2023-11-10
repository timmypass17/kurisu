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
//    var myListStatus: ListStatus?
}

extension Anime: Decodable {
    static var baseURL: String { "https://api.myanimelist.net/v2/anime" }
    static var numEpisodesOrChaptersKey: String { CodingKeys.numEpisodes.rawValue }
    static var fields: [String] { CodingKeys.allCases.map { $0.rawValue } }
    static var episodeOrChaptersString: String { "Episodes" }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case title
        case numEpisodes = "num_episodes"
        case mainPicture = "main_picture"
        case genres
        case status
        case startSeason = "start_season"
        case broadcast
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis
//        case myListStatus = "my_list_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        numEpisodes = try values.decode(Int.self, forKey: .numEpisodes)
        mainPicture = try values.decode(MainPicture.self, forKey: .mainPicture)
        genres = try values.decode([Genre].self, forKey: .genres)
        status = try values.decode(String.self, forKey: .status).snakeToRegularCase()
        startSeason = try values.decodeIfPresent(StartSeason.self, forKey: .startSeason)
        broadcast = try values.decodeIfPresent(Broadcast.self, forKey: .broadcast)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        synopsis = try values.decode(String.self, forKey: .synopsis)
//        myAnimeListStatus = try values.decodeIfPresent(AnimeListStatus.self, forKey: .myListStatus)
    }
}
