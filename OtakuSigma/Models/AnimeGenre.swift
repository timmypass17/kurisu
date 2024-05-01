//
//  AnimeGenre.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/30/23.
//

import Foundation

protocol GenreItemProtocol: Decodable {
    var node: GenreNode { get }
    var myListStatus: ListStatus { get }
}

struct UserGenreResponse<T : GenreItemProtocol>: Decodable {
    var data: [T]
}

struct AnimeGenreItem: GenreItemProtocol {
    var node: GenreNode
    var myListStatus: ListStatus { return myAnimeListStatus }
    var myAnimeListStatus: AnimeListStatus
    
    enum CodingKeys: String, CodingKey {
        case node
        case myAnimeListStatus = "list_status"
    }
}

struct MangaGenreItem: GenreItemProtocol {
    var node: GenreNode
    var myListStatus: ListStatus { return myMangaListStatus }
    var myMangaListStatus: MangaListStatus
    
    enum CodingKeys: String, CodingKey {
        case node
        case myMangaListStatus = "list_status"
    }
}

struct GenreNode: Decodable {
    var genres: [Genre]
}
