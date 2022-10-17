//
//  TweetCounterRootBuilder.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import UIKit

class TweetCounterRootBuilder {
    func buildModule() -> UIViewController {
        let viewController = TweetCounterViewController()
        let authorizeTwitter = TwitterAuthorizationService()
        let authorizeTwitterInteractor = AuthorizeTwitterInteractor(service: authorizeTwitter)
        let tweetPostService = TweetPostService()
        let postTweetInteractor = PostTweetInteractor(service: tweetPostService)
        let presenter = TweetCounterRootPresenter(view: viewController,
                                                  authorizeTwitterInteractor: authorizeTwitterInteractor,
                                                  postTweetInteractor: postTweetInteractor)
        viewController.presenter = presenter
        authorizeTwitterInteractor.output = presenter
        postTweetInteractor.output = presenter
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
