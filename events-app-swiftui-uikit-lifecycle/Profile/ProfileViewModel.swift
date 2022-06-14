//
//  ProfileViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/1/22.
//

import Foundation
import Combine
import os
import UIKit

enum ProfileState {
    case initial
    case loading
    case success(ProfileUserViewModel)
    case error
}

class ProfileViewModel: ObservableObject {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: ProfileViewModel.self))
    
    private let profileFetcher: ProfileFetcher
    private let authListener: AuthListener

    var onTropiesClicked: (() -> ())?
    var onVerificationClicked: (() -> ())?

    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: ProfileState = .initial

    init(profileFetcher: ProfileFetcher, authListener: AuthListener) {
        self.profileFetcher = profileFetcher
        self.authListener = authListener
        
        authListener.userPublisher.sink { [weak self] status in
            switch status {
            case .loggedIn(_):
                self?.loadProfile()
            case .unauthorized:
                DispatchQueue.main.async {
                    self?.state = .initial
                }
            default:
                break
            }
        }
        .store(in: &cancellables)
    }
    
    func loadProfile() {
        Self.logger.trace("Loading profile...")
        self.state = .loading
        self.profileFetcher.fetchProfile(with: "2332") { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                switch result {
                case .success(let profile):
                    self?.state = .success(ProfileUserViewModel(profile))
                    Self.logger.trace("Loaded profile.")
                case .failure(let error):
                    BannerService.shared.show(icon: .failure, title: error.localizedDescription, action: .close)
                    self?.state = .error
                    Self.logger.trace("Error while loading profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func changeAvatar(with image: UIImage) {
        let tokenStore = SecureTokenStore(keychain: .standard)
        let client = HttpAPIClient.shared.tokenSender(store: tokenStore)
        let fileUploader = FileUploader(session: .shared)
        let fileService = FileService(fileManager: .default)
        let manager = FileUploader2(client: client, fileUploader: fileUploader, fileService: fileService)
        manager.fetch(image: image) { [weak self] result in
            switch result {
            case .failure(let error):
                BannerService.shared.show(icon: .failure, title: error.localizedDescription, action: .close)
                print(error)
            case .success(_):
                self?.loadProfile()
            }
        }
    }
}
