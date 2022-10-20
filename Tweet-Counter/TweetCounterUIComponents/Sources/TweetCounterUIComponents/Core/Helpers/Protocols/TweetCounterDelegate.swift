//
//  TweetCounterDelegate.swift
//  
//
//  Created by Omar Alaa on 16/10/2022.
//

import Foundation

public protocol TweetCounterDelegate: AnyObject {
    func didChangeText(newText: String?, isWarningStateOn: Bool)
}
