//
//  TwitterAuthorizationService.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import OAuthSwift
import TweetCounterUtilities

protocol TwitterAuthorizationServiceProtocol {
    func authorizeTwitter(onSuccess: @escaping () -> (),
                          onFailure: @escaping (NetworkError) -> ())
}

class TwitterAuthorizationService: TwitterAuthorizationServiceProtocol {
    func authorizeTwitter(onSuccess: @escaping () -> (),
                          onFailure: @escaping (NetworkError) -> ()) {
        OAuth.shared.oauth.authorize(withCallbackURL: YOUR_CALLBACK_URL) { result in
            switch result {
            case .success:
                onSuccess()
            case .failure(let error):
                let networkError = NetworkError(error: error)
                onFailure(networkError)
            }
        }
    }
}
