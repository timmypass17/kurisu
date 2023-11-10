//
//  WeebResponse.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/22/23.
//

import Foundation

struct MediaListResponse<T: Media>: Codable {
    var data: [Node<T>]
}

struct Node<T: Media>: Codable {
    var node: T
}

struct UserListResponse<T: Media, U: ListStatus>: Codable {
    var data: [UserNode<T, U>]
}

struct UserNode<T: Media, U: ListStatus>: Codable {
    var node: T
    var listStatus: U
    
    enum CodingKeys: String, CodingKey {
        case node
        case listStatus = "list_status"
    }
}
