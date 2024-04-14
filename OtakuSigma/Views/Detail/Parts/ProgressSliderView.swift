//
//  ProgressSliderView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/20/23.
//

import SwiftUI

struct ProgressSliderView<T: Media>: View {
    @Binding var progress: Double
    @EnvironmentObject var mediaDetailViewModel: MediaDetailViewModel<T>
    var media: T // TODO: Binding?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { handleMinus() }) {
                    Image(systemName: "minus")
                }
                
                // TODO: Some animes don't have num count (ex. One Piece)
                Slider(
                    value: $progress,
                    in: 0.0...Double(media.numEpisodesOrChapters),
                    step: 1.0
                ) {
                    Text(media.episodeOrChapterString())
                } minimumValueLabel: {
                    Text("")
                } maximumValueLabel: {
                    Text("")
                }
                Button(action: { handlePlus() }) {
                    Image(systemName: "plus")
                }
            }
            
            Text("Currently on \(media.episodeOrChapterString().lowercased()): \(Int(progress)) / \(media.numEpisodesOrChapters)")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.caption)
        }
    }
    
    func handlePlus() {
        let totalEpi = media.numEpisodesOrChapters > 0 ? media.numEpisodesOrChapters : .max
        progress = min(progress + 1, Double(totalEpi))
    }
    
    func handleMinus() {
        progress = max((progress) - 1, 0)
    }
}

//#Preview {
//    ProgressSliderView(progress: .constant(5), media: sampleAnimes[0])
//}
