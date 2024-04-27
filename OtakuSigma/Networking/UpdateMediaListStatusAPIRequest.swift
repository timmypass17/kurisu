//
//  UpdateAnimeListStatusAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/22/23.
//

import Foundation

struct UpdateMediaListStatusAPIRequest<T: UpdateResponse>: APIRequest {
    var id: Int
    var listStatus: ListStatus
//    var status: String
//    var score: Int
//    var progress: Int
//    var comments: String
    
    var urlRequest: URLRequest {
        let urlComponents = URLComponents(string: "\(T.baseURL)/\(id)/my_list_status")!

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "PUT"
        
        var params: [String: Any] = [
            "status": listStatus.status,
            "score": listStatus.score,
            T.progressKey: listStatus.progress
//            "comments": listStatus.comments
        ]
        
        if let comments = listStatus.comments {
            params["comments"] = comments
        }
        
        print(params)
        
        let queryString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = queryString.data(using: .utf8)

        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return request
    }
    
    func decodeResponse(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let response = try decoder.decode(T.self, from: data)
        return response
    }
}

protocol UpdateResponse: Codable {
    static var baseURL: String { get }
    static var progressKey: String { get }
    
    var status: String { get }
    var score: Int { get }
    var progress: Int { get }
    var updatedAt: String { get }
    var comments: String { get }
    
    var listStatus: ListStatus { get }
}

struct AnimeUpdateResponse: UpdateResponse {
    static var baseURL: String = "https://api.myanimelist.net/v2/anime"
    static var progressKey: String = "num_watched_episodes" // key is different (i.e. num_watched_episodes != num_episodes_watched)
    
    var status: String
    var score: Int
    var numEpisodesWatched: Int
    var progress: Int { numEpisodesWatched }
    var updatedAt: String
    var comments: String
    
    var listStatus: ListStatus { // TODO: Beautiful generic
        return AnimeListStatus(status: status, score: score, numEpisodesWatched: numEpisodesWatched, comments: comments)
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numEpisodesWatched = "num_episodes_watched" // key is different
        case updatedAt = "updated_at"
        case comments
    }
}

struct MangaUpdateResponse: UpdateResponse {
    static var baseURL: String = "https://api.myanimelist.net/v2/manga"
    static var progressKey: String = CodingKeys.numChaptersRead.rawValue
    
    var status: String
    var score: Int
    var numChaptersRead: Int
    var progress: Int { numChaptersRead }
    var updatedAt: String
    var comments: String
    
    var listStatus: ListStatus {
        return MangaListStatus(status: status, score: score, numChaptersRead: numChaptersRead)
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case score
        case numChaptersRead = "num_chapters_read"
        case updatedAt = "updated_at"
        case comments
    }
}
