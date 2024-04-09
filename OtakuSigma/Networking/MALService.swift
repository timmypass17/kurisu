//
//  MALService.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation

protocol MediaService {
    func getUserList<T: Media>(status: String, sort: String, fields: [String]) async throws -> [T]
    func getMediaItems<T: Media>(title: String) async throws -> [T]
    func getMediaRanking<T: Media>(rankingType: String, limit: Int, offset: Int) async throws -> [T]
    func getSeasonalAnime<T: Media>(year: String, season: Season, sort: RankingSort, limit: Int, offset: Int) async throws -> [T]
    func getMediaDetail<T: Media>(id: Int, fields: [String]) async throws -> T
    func updateMediaListStatus<T: UpdateResponse>(id: Int, status: String, score: Int, progress: Int, comments: String) async throws -> T
    func deleteMediaItem<T: Media>(id: Int) async throws -> T?  // return not used
    func getUser() async throws -> User
    func getAdditionalUserListInfo<T: GenreItemProtocol>() async throws -> [T]
}

struct MALService: MediaService {
    
    func getUserList<T: Media>(status: String, sort: String, fields: [String]) async throws -> [T] {
        let request = UserListAPIRequest<T>(status: status, sort: sort, fields: fields)
        let animeListResponse = try await sendRequest(request)
        return animeListResponse
    }
    
    func getMediaItems<T: Media>(title: String) async throws -> [T] {
        let request = WeebListAPIRequest<T>(title: title, fields: T.fields)
        let data = try await sendRequest(request)
        return data
    }
    
    func getMediaRanking<T: Media>(rankingType: String, limit: Int, offset: Int) async throws -> [T] {
        let request = RankingAPIRequest<T>(rankingType: rankingType, fields: T.fields, limit: limit, offset: offset)
        let data = try await sendRequest(request)
        return data
    }
    
    func getSeasonalAnime<T: Media>(year: String, season: Season, sort: RankingSort, limit: Int, offset: Int) async throws -> [T] {
        let request = SeasonalAnimeAPIRequest<T>(year: year, season: season, sort: sort, limit: limit, offset: offset)
        let data = try await sendRequest(request)
        return data
    }
    
    func getMediaDetail<T: Media>(id: Int, fields: [String]) async throws -> T {
        let request = MediaDetailAPIRequest<T>(id: id, fields: fields)
        let data = try await sendRequest(request)
        return data
    }
    
    func updateMediaListStatus<T: UpdateResponse>(id: Int, status: String, score: Int, progress: Int, comments: String) async throws -> T {
        let request = UpdateMediaListStatusAPIRequest<T>(id: id, status: status, score: score, progress: progress, comments: comments)
        let data = try await sendRequest(request)
        return data
    }
    
    func deleteMediaItem<T: Media>(id: Int) async throws -> T? {
        let request = DeleteMediaAPIRequest<T>(id: id)
        try await sendRequest(request)
        return nil
    }
    
    func getUser() async throws -> User {
        let request = UserAPIRequest()
        let user = try await sendRequest(request)
        return user
    }
    
    func getAdditionalUserListInfo<T: GenreItemProtocol>() async throws -> [T] {
        let request = UserAddtionalAPIRequest<T>()
        let data = try await sendRequest(request)
        return data
    }

}

enum TokenError: Error {
    case missingAccessToken
}
