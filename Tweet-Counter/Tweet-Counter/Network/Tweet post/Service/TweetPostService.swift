//
//  TweetPostService.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import TweetCounterUtilities

protocol TweetPostServiceProtocol {
    func postTweetWith(text: String,
                       onSuccess: @escaping () -> (),
                       onFailure: @escaping (NetworkError) -> ())
}

class TweetPostService: TweetPostServiceProtocol {
    func postTweetWith(text: String,
                       onSuccess: @escaping () -> (),
                       onFailure: @escaping (NetworkError) -> ()) {
        let parameters = ["text": text]
        let headers = ["content-type": "application/json"]
        OAuth.shared.oauth.client.post(TWITTER_BASE_URL + "/2/tweets",
        parameters: parameters,
        headers: headers) { result in
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
