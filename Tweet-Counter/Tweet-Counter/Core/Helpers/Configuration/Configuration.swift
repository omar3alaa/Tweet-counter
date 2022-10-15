//
//  Configuration.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation

class Configuration {
    let maxWeightedTweetLength: Int
    let transformedURLLength: Int
    let ranges: [NSRange]

    struct ConfigurationJSON: Decodable {
        let maxWeightedTweetLength: Int
        let transformedURLLength: Int
        let ranges: [[String: Int]]
    }

    init?(jsonData: Data) {
        do {
            let config = try JSONDecoder().decode(ConfigurationJSON.self, from: jsonData)

            self.maxWeightedTweetLength = config.maxWeightedTweetLength
            self.transformedURLLength = config.transformedURLLength
            var ranges: [NSRange] = []

            for rangeDict in config.ranges {
                guard let start = rangeDict["start"],
                      let end = rangeDict["end"] else {
                    return nil
                }
                var range = NSMakeRange(NSNotFound, NSNotFound)
                range.location = start
                range.length = end - range.location
                ranges.append(range)
            }
            self.ranges = ranges
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func buildConfiguration() -> Configuration? {
        guard let urlPath = Bundle.main.url(forResource: "config", withExtension: "json"),
              let jsonData = try? Data(contentsOf: urlPath) else {
            return nil
        }

        return Configuration(jsonData: jsonData)
    }

    // For unit testing
    static func configuration(from jsonString: String) -> Configuration? {
        let jsonData = Data(jsonString.utf8)

        return Configuration(jsonData: jsonData)
    }
}
