//
//  Settings.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/27/23.
//

import Foundation

struct Settings {
    static var shared = Settings()
    private let defaults = UserDefaults.standard
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let accessTokenLastUpdatedKey = "accessTokenLastUpdated"
    static let accessTokenDurationInSeconds: TimeInterval = 2682000  // 31 days
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        defaults.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
              let data = string.data(using: .utf8) else {
            return nil
        }
        
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    var accessToken: String? {
        get {
            return unarchiveJSON(key: accessTokenKey)
        }
        set {
            archiveJSON(value: newValue, key: accessTokenKey)
        }
    }
    
    var refreshToken: String? {
        get {
            return unarchiveJSON(key: refreshTokenKey)
        }
        set {
            archiveJSON(value: newValue, key: refreshTokenKey)
        }
    }
    
    var accessTokenLastUpdated: Date? {
        get {
            return unarchiveJSON(key: accessTokenLastUpdatedKey)
        }
        set {
            archiveJSON(value: newValue, key: accessTokenLastUpdatedKey)
        }
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
