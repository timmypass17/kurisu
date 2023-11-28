//
//  DeleteMediaAPIRequest.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/26/23.
//

import Foundation

struct DeleteMediaAPIRequest<T: Media>: APIRequest {
    var id: Int
    
    var urlRequest: URLRequest {
        let urlComponents = URLComponents(string: "\(T.baseURL)/\(id)/my_list_status")!

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"

        if let accessToken = Settings.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    func decodeResponse(data: Data) throws {
        return
    }
}
