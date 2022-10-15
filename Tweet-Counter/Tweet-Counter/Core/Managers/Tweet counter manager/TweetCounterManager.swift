//
//  TweetCounterManager.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation

class TweetCounterManager: TweetCounterManagerProtocol {
    
    // MARK: - Properties
    private let configuration: Configuration? = Configuration.buildConfiguration()
    var maximumChractersAllowed: Int {
        return configuration?.maxWeightedTweetLength ?? 0
    }
    
    func getTweetCountFor(tweet: String) -> Int {
        var tweet = tweet
        var charactersCount = 0
        let whiteSpacesCount = getWhiteSpacesCountIn(tweet: tweet)
        let totalUrlsCharactersCount = removeUrlsFrom(tweet: &tweet)
        let remainingCharactersCount = calculateRemainingCharactersIn(tweet: tweet)
        charactersCount = whiteSpacesCount + totalUrlsCharactersCount + remainingCharactersCount
        return charactersCount
    }
}

private extension TweetCounterManager {
    func getWhiteSpacesCountIn(tweet: String) -> Int {
        let whiteSpacesCount = tweet.reduce(0) { $1.isWhitespace ? $0 + 1 : $0}
        return whiteSpacesCount
    }
    
    /**
     A function to remove urls from a specific string in place, so this function ALTERS the string, take care while using it.
     this function returns all urls' characters count that have been removed, this calculation implemented according to twitter mechanism
     
     - Parameter tweet: Address to the string it will search in
     */
    func removeUrlsFrom(tweet: inout String) -> Int {
        let splits = tweet.split(whereSeparator: \.isWhitespace)
        if tweet.isEmpty {
            return 0
        } else if splits.isEmpty {
            if tweet.isValidUrlUsingTwitterRegex {
                return configuration?.transformedURLLength ?? 0
            } else {
                return 0
            }
        } else {
            var newSplits: [String.SubSequence] = []
            let numberOfUrlsFound = splits.reduce(0) {
                if String($1).isValidUrlUsingTwitterRegex {
                    return $0 + 1
                } else {
                    newSplits.append($1)
                    return $0
                }
            }
            tweet = newSplits.reduce("", +)
            let totalUrlsCharactersFound = numberOfUrlsFound * (configuration?.transformedURLLength ?? 0)
            return totalUrlsCharactersFound
        }
    }
    
    func calculateRemainingCharactersIn(tweet: String) -> Int {
        guard let configuration = configuration else { return 0 }
        var charactersCount = 0
        for char in tweet {
            var charCount = 0
            // Gets the unicode of this char
            let uniCode = String(char).unicodeScalars.first!.value
            
            for range in configuration.ranges {
                // Check if this unicode falls through the range that has weight 1 in config, then make charCount = 1 and break the loop
                if (uniCode >= range.lowerBound && uniCode <= range.upperBound) {
                    charCount = 1
                    break
                    // Check if this unicode is already lower than the lowerbound of this current range in iteration, then it must be iterated in previous ranges without falling through them, so it's definitly out of these ranges so make charCount = 2 and break the loop
                } else if uniCode <= range.lowerBound {
                    charCount = 2
                    break
                }
            }
            if charCount == 0 {
                charCount = 2
            }
            charactersCount += charCount
        }
        return charactersCount
    }
}
