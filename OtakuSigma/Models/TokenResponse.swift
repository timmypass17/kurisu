//
//  TokenResponse.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/27/23.
//

import Foundation

struct TokenResponse: Decodable {
    var accessToken: String
    var expiresIn: Int  // seconds
    var refreshToken: String
}
