//
//  String+Regex.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
extension String {
    var isValidUrlUsingTwitterRegex: Bool {
        let urlRegEx = Regexp.TWUValidURLPatternString
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self) && self.count <= 4088
    }
}
