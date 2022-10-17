//
//  TweetCounterRootProtocols.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import TweetCounterUtilities
import TweetCounterUIComponents

protocol TweetCounterRootViewProtocol: AnyObject {
    func setScreenTitleWith(text: String)
    func toggleCopyTextButtonEnablement(isEnabled: Bool)
    func toggleClearTextButtonEnablement(isEnabled: Bool)
    func togglePostTweetButtonEnablement(isEnabled: Bool)
    func clearText()
    func copyTextToClipboard(textToCopy: String?)
    func showErrorToastWith(dataModel: ToastDataModel)
    func showSuccessToastWith(dataModel: ToastDataModel)
}

protocol TweetCounterRootPresenterProtocol {
    func viewDidLoad()
    func didChangeText(newText: String?)
    func didTapCopyTextButton()
    func didTapClearTextButton()
    func didTapPostTweetButton()
    func typedCharactersCountChanged(didReachMaximumCharactersCountAllowed: Bool)
}

protocol AuthorizeTwitterInteractorProtocol {
    func authorizeTwitter()
}

protocol AuthorizeTwitterInteractorOutputProtocol: AnyObject {
    func didAuthorizeTwitterSuccessfully()
    func didFailToAuthorizeTwitterWith(error: NetworkError)
}

protocol PostTweetInteractorProtocol {
    func postTweetWith(text: String)
}

protocol PostTweetInteractorOutputProtocol: AnyObject {
    func didPostTweetSuccessfully()
    func didFailToPostTweetWith(error: NetworkError)
}
