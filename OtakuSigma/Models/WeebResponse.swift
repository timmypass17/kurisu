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

