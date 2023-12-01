//
//  ProfileViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
import UIKit

//
//  ProfileViewModel.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 10/25/23.
//

import Foundation
import UIKit

@MainActor
class ProfileViewModel: ObservableObject {
//    @Published var user: User?
    @Published var appState: AppState
//    var isLoggedIn: Bool { appState.state == .loggedIn(<#T##User#>) }
    
    var authService: OAuthService!
    let mediaService: MediaService
    
    init(appState: AppState, mediaService: MediaService) {
        self.appState = appState
        self.mediaService = mediaService
        
//        Task {
//            await loadUser()
//        }
//        
    }
    
//    func loadUser() async {
//        do {
//            user = try await mediaService.getUser()
//        } catch {
//            print("[ProfileViewModel] Error fetching user: \(error)")
//        }
//    }
    
    func loginButtonTapped() {
        guard let authorizationURL = authService.buildAuthorizationURL() else { return }
        UIApplication.shared.open(authorizationURL) // open myanimelist login
    }
}

