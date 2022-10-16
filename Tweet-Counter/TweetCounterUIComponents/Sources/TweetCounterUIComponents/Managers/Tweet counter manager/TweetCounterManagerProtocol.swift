//
//  TweetCounterManagerProtocol.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation

protocol TweetCounterManagerProtocol {
    var maximumChractersAllowed: Int { get }
    func getTweetCountFor(tweet: String) -> Int
}
