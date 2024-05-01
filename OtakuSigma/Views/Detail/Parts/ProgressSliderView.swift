//
//  ProgressSliderView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/20/23.
//

import SwiftUI

struct ProgressSliderView<T: Media>: View {
    @Binding var progress: Double
    var media: T
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { handleMinus() }) {
                    Image(systemName: "minus")
                }
                
                Slider(
                    value: $progress,
                    in: 0.0...Double(media.numEpisodesOrChapters),
                    step: 1.0
                ) {
                    Text(media.getEpisodeOrChapterString())
                } minimumValueLabel: {
                    Text("")
                } maximumValueLabel: {
                    Text("")
                }
                Button(action: { handlePlus() }) {
                    Image(systemName: "plus")
                }
            }
            
            Text("Currently on \(media.getEpisodeOrChapterString().lowercased()): \(Int(progress)) / \(media.numEpisodesOrChapters)")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.caption)
        }
    }
    
    func handlePlus() {
        let totalEpi = media.numEpisodesOrChapters > 0 ? media.numEpisodesOrChapters : .max
        progress = min(progress + 1, Double(totalEpi))
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func handleMinus() {
        progress = max((progress) - 1, 0)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

//#Preview {
//    ProgressSliderView(progress: .constant(5), media: sampleAnimes[0])
//}
