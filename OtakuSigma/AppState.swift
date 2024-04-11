//
//  App.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation

// Contains app-level information (i.e. user info)
class AppState {
    var state: State = .unregistered
    
    var isLoggedIn: Bool {
        if case .loggedIn(_) = state { return true }
        return false
    }
    
    enum State {
        case unregistered
        case loggedIn(User)
        case sessionExpired(User)
    }
    
    init() {
        Task {
            await loadUser()
        }
    }
    
    func loadUser() async {
        do {
            guard let accessToken = Settings.shared.accessToken else { return }
            let mediaService = MALService()
            let user = try await mediaService.getUser(accessToken: accessToken)
            state = .loggedIn(user)
        } catch {
            print("[ProfileViewModel] Error fetching user: \(error)")
        }
    }

}
