//
//  AppRoute.swift
//  Lingvistik
//
//  Created by Екатерина Яцкевич on 17.04.25.
//
import Foundation
import SwiftUI
import Combine

enum AppRoute {
    case splash
    case auth
    case languageSelection
    case mainTab
}

final class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    
    private var authManager: AuthenticationManager
    private var userSettings: UserSettings
    private var cancellables = Set<AnyCancellable>()
    
    private var hasShownSplash = false
    
    init(authManager: AuthenticationManager, userSettings: UserSettings) {
        self.authManager = authManager
        self.userSettings = userSettings
        observeAuthState()
    }
    
    private func observeAuthState() {
        authManager.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                
                guard self.hasShownSplash else { return }
                
                if isAuthenticated {
                    if self.userSettings.selectedLanguage == nil {
                        self.currentRoute = .languageSelection
                    } else {
                        self.currentRoute = .mainTab
                    }
                } else {
                    self.currentRoute = .auth
                }
            }
            .store(in: &cancellables)
    }

    func determineRouteAfterSplash() {
        hasShownSplash = true
        
        if authManager.isAuthenticated {
            if userSettings.selectedLanguage == nil {
                currentRoute = .languageSelection
            } else {
                currentRoute = .mainTab
            }
        } else {
            currentRoute = .auth
        }
    }

    func logout() {
        do {
            try authManager.signOut()
            userSettings.selectedLanguage = nil
            currentRoute = .auth
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }
}
