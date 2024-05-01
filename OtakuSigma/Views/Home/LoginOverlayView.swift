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
            Text("Log into MyAnimeList")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("Authorize account to access app's full functionality")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Login") {
                appState.isPresentWebView = true
            }
            .font(.title3)
            .fontWeight(.semibold)

        }
        .padding()
    }
}
