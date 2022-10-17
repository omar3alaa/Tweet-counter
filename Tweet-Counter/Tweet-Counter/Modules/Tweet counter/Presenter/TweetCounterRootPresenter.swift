//
//  TweetCounterRootPresenter.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import TweetCounterUtilities
import TweetCounterUIComponents

class TweetCounterRootPresenter: TweetCounterRootPresenterProtocol {
    private weak var view: TweetCounterRootViewProtocol?
    private let authorizeTwitterInteractor: AuthorizeTwitterInteractorProtocol
    private let postTweetInteractor: PostTweetInteractorProtocol
    private var text: String?
    
    init(view: TweetCounterRootViewProtocol,
         authorizeTwitterInteractor: AuthorizeTwitterInteractorProtocol,
         postTweetInteractor: PostTweetInteractorProtocol) {
        self.view = view
        self.authorizeTwitterInteractor = authorizeTwitterInteractor
        self.postTweetInteractor = postTweetInteractor
    }
    
    func viewDidLoad() {
        disableUserInteractionEnablement()
        view?.setScreenTitleWith(text: "Twitter character count")
    }
    
    func didChangeText(newText: String?) {
        text = newText
        if let newText = newText, !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.toggleCopyTextButtonEnablement(isEnabled: true)
            view?.toggleClearTextButtonEnablement(isEnabled: true)
        } else {
            disableUserInteractionEnablement()
        }
    }
    
    func didTapCopyTextButton() {
        let dataModel = ToastDataModel(iconImageName: .success,
                                       actionButtonTitle: nil,
                                       message: "Text is copied successfully to clipboard!",
                                       actionButtonClosure: nil)
        view?.copyTextToClipboard(textToCopy: text)
        view?.showSuccessToastWith(dataModel: dataModel)
    }
    
    func didTapClearTextButton() {
        view?.clearText()
    }
    
    func didTapPostTweetButton() {
        authorizeTwitterInteractor.authorizeTwitter()
    }
    
    func typedCharactersCountChanged(didReachMaximumCharactersCountAllowed: Bool) {
        view?.togglePostTweetButtonEnablement(isEnabled: !didReachMaximumCharactersCountAllowed)
    }
}

extension TweetCounterRootPresenter: AuthorizeTwitterInteractorOutputProtocol {
    func didAuthorizeTwitterSuccessfully() {
        guard let text = text else {
            let dataModel = ToastDataModel(iconImageName: .error,
                                           actionButtonTitle: nil,
                                           message: "Text shouldn't be empty!",
                                           actionButtonClosure: nil)
            view?.showErrorToastWith(dataModel: dataModel)
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let dataModel = ToastDataModel(iconImageName: .error,
                                           actionButtonTitle: nil,
                                           message: "Text shouldn't be empty!",
                                           actionButtonClosure: nil)
            view?.showErrorToastWith(dataModel: dataModel)
            return
        }
        postTweetInteractor.postTweetWith(text: text)
    }
    
    func didFailToAuthorizeTwitterWith(error: NetworkError) {
        let dataModel = ToastDataModel(iconImageName: .error,
                                       actionButtonTitle: nil,
                                       message: "Something went wrong!",
                                       actionButtonClosure: nil)
        view?.showErrorToastWith(dataModel: dataModel)
    }
}

extension TweetCounterRootPresenter: PostTweetInteractorOutputProtocol {
    func didPostTweetSuccessfully() {
        let dataModel = ToastDataModel(iconImageName: .error,
                                       actionButtonTitle: nil,
                                       message: "Your tweet is posted successfully!",
                                       actionButtonClosure: nil)
        view?.showSuccessToastWith(dataModel: dataModel)
        view?.clearText()
    }
    
    func didFailToPostTweetWith(error: TweetCounterUtilities.NetworkError) {
        let dataModel = ToastDataModel(iconImageName: .error,
                                       actionButtonTitle: nil,
                                       message: "Something went wrong!",
                                       actionButtonClosure: nil)
        view?.showErrorToastWith(dataModel: dataModel)
    }
}

private extension TweetCounterRootPresenter {
    func disableUserInteractionEnablement() {
        view?.toggleCopyTextButtonEnablement(isEnabled: false)
        view?.toggleClearTextButtonEnablement(isEnabled: false)
        view?.togglePostTweetButtonEnablement(isEnabled: false)
    }
}
