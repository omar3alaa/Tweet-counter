//
//  TweetCounterViewFactory.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
import UIKit

class TweetCounterViewModelFactory {
    func initTweetCounterViewModel() -> TweetCounterViewModel {
        let tweetCounterManager = TweetCounterManager()
        let viewModel = TweetCounterViewModel(tweetCounterManager: tweetCounterManager)
        return viewModel
    }
}
