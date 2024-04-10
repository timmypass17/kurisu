//
//  MediaStatus.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/9/24.
//

import Foundation
import SwiftUI

protocol MediaStatus: Codable {
    var description: String { get }
    var color: Color { get }
}

enum AnimeStatus: String, MediaStatus {
    case currentlyAiring = "currently_airing"
    case notYetAired = "not_yet_aired"
    case finishedAiring = "finished_airing"
    
    var description: String {
        return self.rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    var color: Color {
        switch self {
        case .currentlyAiring:
            return .green
        case .notYetAired:
            return .yellow
        case .finishedAiring:
            return .blue
        }
    }
}

enum MangaStatus: String, MediaStatus {
    case currentlyPublishing = "currently_publishing"
    case finished = "finished"
    case onHiatus = "on_hiatus"
    
    var description: String {
        return self.rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    var color: Color {
        switch self {
        case .currentlyPublishing:
            return .green
        case .finished:
            return .blue
        case .onHiatus:
            return .pink
        }
    }
}
