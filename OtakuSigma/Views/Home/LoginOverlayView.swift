//
//  LoginOverlayView.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 4/9/24.
//

import SwiftUI

struct LoginOverlayView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Login to your MAL account")
                .font(.title2)
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
            
            Text("Saving viewing progression, score, and notes requires a MyAnimeList account.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Login") {
                
                appState.isPresentingLoginConfirmation = true
            }
            .buttonStyle(.borderedProminent)
//            .font(.title3)
            .padding(.top, 4)

        }
        .padding()
    }
}
