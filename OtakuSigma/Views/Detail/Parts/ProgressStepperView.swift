//
//  ProgressionStepperView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/21/24.
//

import SwiftUI

struct ProgressStepper<T: Media>: View {
    @Binding var progress: Double
    var media: T

    var body: some View {
        VStack(spacing: 0) {
            Stepper {
                TextField(
                    "Progression",
                    value: $progress,
                    formatter: NumberFormatter(),
                    prompt: Text("0")
                )
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            } onIncrement: {
                handlePlus()
            } onDecrement: {
                handleMinus()
            }
            
            Text("Currently on \(media.getEpisodeOrChapterString().lowercased()): \(Int(progress)) / ?")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.caption)
                .padding(.top)
        }
    }
    
    func handlePlus() {
        progress += 1
    }
    
    func handleMinus() {
        progress = max((progress) - 1, 0)
    }
}
