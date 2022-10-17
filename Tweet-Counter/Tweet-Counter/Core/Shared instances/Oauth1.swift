//
//  Oauth1.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import OAuthSwift

class OAuth {
    private init() { }
    static let shared = OAuth()
    
    lazy var oauth: OAuth1Swift = {
        let oauth = OAuth1Swift(consumerKey: YOUR_API_KEY,
                                consumerSecret: YOUR_API_KEY_SECRET,
                                requestTokenUrl: "\(TWITTER_OAUTH_BASE_URL)/request_token",
                                authorizeUrl: "\(TWITTER_OAUTH_BASE_URL)/authorize",
                                accessTokenUrl: "\(TWITTER_OAUTH_BASE_URL)/access_token")
        return oauth
    }()
    
}
