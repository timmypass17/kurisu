//
//  MediaStatusView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/21/24.
//

import SwiftUI

struct MediaStatusView: View {
    var item: Media
    
    var body: some View {
        HStack {
            if let status = item.status as? AnimeStatus {
                if status == .currentlyAiring {
                    Image(systemName: "clock")
                    Text("Next Episode: \(item.nextReleaseString)")
                } else if status == .notYetAired {
                    Image(systemName: "clock")
                    Text("Airing Date: \(item.nextReleaseString)")
                } else if status == .finishedAiring {
                    Image(systemName: "flag")
                    Text("Finished Airing")
                }
            }
        }
        .foregroundColor(.secondary)
        .font(.caption)
    }
}

//#Preview {
//    MediaStatusView()
//}
