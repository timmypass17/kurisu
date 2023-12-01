//
//  App.swift
//  OtakuSigma
//
//  Created by Timmy Nguyen on 11/28/23.
//

import Foundation

class AppState {
    var state: State = .unregistered

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
            let mediaService = MALService()
            
            let user = try await mediaService.getUser()
            state = .loggedIn(user)
        } catch {
            print("[ProfileViewModel] Error fetching user: \(error)")
        }
    }
}
