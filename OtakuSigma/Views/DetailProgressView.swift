//
//  DetailProgressView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct DetailProgressView<T: Media>: View {
    var media: T
    var progress: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            ProgressView(
                value: Float(progress),
                total: Float(media.numEpisodesOrChapters)
            ) {
                HStack(spacing: 4) {
                    StatusView(status: media.status, color: .green)

                    Spacer()
                    
                    Text("\(T.episodeOrChaptersString):")
                        .font(.caption)
                    
                    Text("\(progress) /")
                        .font(.caption)
                    
                    Text("\(media.numEpisodesOrChapters)")
                        .font(.caption)
                }
            }
            .progressViewStyle(.linear)
            
            Label("Next Episode: ", systemImage: "clock")
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

struct DetailProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DetailProgressView(media: sampleAnimes[0], progress: 11)
    }
}
