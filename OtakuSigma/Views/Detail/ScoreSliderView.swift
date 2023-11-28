//
//  ScoreSliderView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/21/23.
//

import SwiftUI

struct ScoreSliderView: View {
    @Binding var progress: Double
    let total = 10.0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { handleMinus() }) {
                    Image(systemName: "minus")
                }
                
                // TODO: Some animes don't have num count (ex. One Piece)
                Slider(
                    value: $progress,
                    in: 0.0...total,
                    step: 1.0
                ) {
                    Text("Score")
                } minimumValueLabel: {
                    Text("")
                } maximumValueLabel: {
                    Text("")
                }
                Button(action: { handlePlus() }) {
                    Image(systemName: "plus")
                }
            }
            
            Text("Your score: \(Int(progress)) / \(Int(total))")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.caption)
        }
    }
    
    func handlePlus() {
        progress = min(progress + 1.0, total)
    }
    
    func handleMinus() {
        progress = max((progress) - 1.0, 0)
    }
}

#Preview {
    ScoreSliderView(progress: .constant(8))
}
