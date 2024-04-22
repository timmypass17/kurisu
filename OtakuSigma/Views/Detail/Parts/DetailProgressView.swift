//
//  DetailProgressView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/9/23.
//

import SwiftUI

struct DetailProgressView<T: Media>: View {
    var media: T
    var progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProgressView(
                value: Float(progress),
                total: Float(media.numEpisodesOrChapters)
            ) {
                HStack(spacing: 4) {
                    StatusView(status: media.status.description, color: .green)

                    Spacer()
                    
                    Text("\(T.episodesOrChaptersString):")
                        .font(.caption)
                    
                    Text("\(Int(progress)) /")
                        .font(.caption)
                    
                    Text("\(media.numEpisodesOrChapters)")
                        .font(.caption)
                }
            }
            .progressViewStyle(.linear)
            
            MediaStatusView(item: media)
//            Label("Next Episode: ", systemImage: "clock")
//                .foregroundColor(.secondary)
//                .font(.caption)
        }
    }
}

//struct DetailProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailProgressView(media: sampleAnimes[0])
//    }
//}
