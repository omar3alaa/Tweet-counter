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
        setupViewInitialState()
    }
    
    func didChangeText(newText: String?) {
        text = newText
        if let newText = newText, !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.toggleCopyTextButtonEnablement(isEnabled: true)
            view?.toggleClearTextButtonEnablement(isEnabled: true)
        } else {
            view?.toggleCopyTextButtonEnablement(isEnabled: false)
            view?.toggleClearTextButtonEnablement(isEnabled: false)
        }
    }
    
    func didTapCopyTextButton() {
        let toastDataModel = ToastDataModel(iconImageName: .success,
                                            actionButtonTitle: nil,
                                            message: "Text is copied successfully to clipboard!",
                                            actionButtonClosure: nil)
        view?.copyTextToClipboard(textToCopy: text)
        view?.showSuccessToastWith(dataModel: toastDataModel)
    }
    
    func didTapClearTextButton() {
        view?.clearText()
    }
    
    func didTapPostTweetButton() {
        setupViewUponLoadingState()
        authorizeTwitterInteractor.authorizeTwitter()
    }
    
    func warningStateChanged(isWarningStateOn: Bool) {
        guard let text = text else {
            view?.togglePostTweetButtonEnablement(isEnabled: false)
            return
        }
        if isWarningStateOn || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.togglePostTweetButtonEnablement(isEnabled: false)
        } else {
            view?.togglePostTweetButtonEnablement(isEnabled: true)
        }
    }
}

extension TweetCounterRootPresenter: AuthorizeTwitterInteractorOutputProtocol {
    func didAuthorizeTwitterSuccessfully() {
        guard let text = text else {
            setupViewUponTweetingEmptyOrNilText()
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setupViewUponTweetingEmptyOrNilText()
            return
        }
        postTweetInteractor.postTweetWith(text: text)
    }
    
    func didFailToAuthorizeTwitterWith(error: NetworkError) {
        setupViewUponErrorState()
    }
}

extension TweetCounterRootPresenter: PostTweetInteractorOutputProtocol {
    func didPostTweetSuccessfully() {
        let toastDataModel = ToastDataModel(iconImageName: .success,
                                            actionButtonTitle: nil,
                                            message: "Your tweet is posted successfully!",
                                            actionButtonClosure: nil)
        view?.clearText()
        view?.showSuccessToastWith(dataModel: toastDataModel)
        view?.toggleLoaderVisibility(showLoader: false)
        view?.toggleTextViewEnablement(isEnabled: true)
    }
    
    func didFailToPostTweetWith(error: TweetCounterUtilities.NetworkError) {
        setupViewUponErrorState()
    }
}

private extension TweetCounterRootPresenter {
    func setupViewInitialState() {
        view?.toggleCopyTextButtonEnablement(isEnabled: false)
        view?.toggleClearTextButtonEnablement(isEnabled: false)
        view?.togglePostTweetButtonEnablement(isEnabled: false)
        view?.setScreenTitleWith(text: "Twitter character count")
    }
    
    func setupViewUponTweetingEmptyOrNilText() {
        let toastDataModel = ToastDataModel(iconImageName: .error,
                                            actionButtonTitle: nil,
                                            message: "Text shouldn't be empty!",
                                            actionButtonClosure: nil)
        view?.showErrorToastWith(dataModel: toastDataModel)
        view?.toggleLoaderVisibility(showLoader: false)
        view?.toggleCopyTextButtonEnablement(isEnabled: false)
        view?.toggleClearTextButtonEnablement(isEnabled: false)
        view?.togglePostTweetButtonEnablement(isEnabled: false)
        view?.toggleTextViewEnablement(isEnabled: true)
    }
    
    func setupViewUponLoadingState() {
        view?.toggleLoaderVisibility(showLoader: true)
        view?.toggleCopyTextButtonEnablement(isEnabled: false)
        view?.toggleClearTextButtonEnablement(isEnabled: false)
        view?.togglePostTweetButtonEnablement(isEnabled: false)
        view?.toggleTextViewEnablement(isEnabled: false)
    }
    
    func setupViewUponErrorState() {
        let toastDataModel = ToastDataModel(iconImageName: .error,
                                            actionButtonTitle: nil,
                                            message: "Something went wrong!",
                                            actionButtonClosure: nil)
        view?.showErrorToastWith(dataModel: toastDataModel)
        view?.toggleLoaderVisibility(showLoader: false)
        view?.toggleCopyTextButtonEnablement(isEnabled: true)
        view?.toggleClearTextButtonEnablement(isEnabled: true)
        view?.togglePostTweetButtonEnablement(isEnabled: true)
        view?.toggleTextViewEnablement(isEnabled: true)
    }
}
