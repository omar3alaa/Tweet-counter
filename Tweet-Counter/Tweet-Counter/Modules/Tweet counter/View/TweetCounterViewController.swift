//
//  TweetCounterViewController.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import UIKit
import TweetCounterUIComponents
import OAuthSwift

class TweetCounterViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var tweetCounterView: TweetCounterView!
    @IBOutlet private weak var darkModeIconImageView: UIImageView!
    @IBOutlet private weak var darkModeSwitch: UISwitch!
    @IBOutlet private weak var copyTextButton: UIButton!
    @IBOutlet private weak var clearTextButton: UIButton!
    @IBOutlet private weak var postTweetButton: UIButton!
    
    // MARK: - Properties
    var presenter: TweetCounterRootPresenterProtocol?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    // MARK: UIResponders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: Actions
    @IBAction func didTapCopyTextButton(_ sender: Any) {
        presenter?.didTapCopyTextButton()
    }
    
    @IBAction func didTapClearTextButton(_ sender: Any) {
        presenter?.didTapClearTextButton()
    }
    
    @IBAction func didTapPostTweetButton(_ sender: Any) {
        presenter?.didTapPostTweetButton()
    }
    
    @IBAction func didToggleDarkMode(_ sender: Any) {
        guard let window = UIApplication.shared.windows.first else { return }
        let isDarkModeNow = traitCollection.userInterfaceStyle == .dark
        let newInterfaceStyle: UIUserInterfaceStyle = isDarkModeNow ? .light : .dark
        setupDarkModeToggleColors(userInterfaceStyle: newInterfaceStyle)
        UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = newInterfaceStyle
        }, completion: nil)
    }
}

// MARK: Private helpers
private extension TweetCounterViewController {
    func setupView() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        setupDarkModeToggleColors(userInterfaceStyle: userInterfaceStyle)
        tweetCounterView.setDelegate(delegate: self)
    }
    
    func setupDarkModeToggleColors(userInterfaceStyle: UIUserInterfaceStyle) {
        let isDarkMode = userInterfaceStyle == .dark
        darkModeIconImageView.tintColor = isDarkMode ? .white : UIColor(hexString: "#FDB813")
        darkModeSwitch.isOn = isDarkMode
    }
    
    func toggleButtonEnablement(button: UIButton, isEnabled: Bool) {
        button.isUserInteractionEnabled = isEnabled
        if isEnabled {
            button.alpha = 1
        } else {
            button.alpha = 0.6
        }
    }
}

// MARK: - TweetCounterDelegate
extension TweetCounterViewController: TweetCounterDelegate {
    func didChangeText(newText: String?) {
        presenter?.didChangeText(newText: newText)
    }
    
    func typedCharactersCountChanged(didReachMaximumCharactersCountAllowed: Bool) {
        presenter?.typedCharactersCountChanged(didReachMaximumCharactersCountAllowed: didReachMaximumCharactersCountAllowed)
    }
}

// MARK: -
extension TweetCounterViewController: TweetCounterRootViewProtocol {
    func setScreenTitleWith(text: String) {
        title = text
    }
    
    func toggleCopyTextButtonEnablement(isEnabled: Bool) {
        toggleButtonEnablement(button: copyTextButton, isEnabled: isEnabled)
    }
    
    func toggleClearTextButtonEnablement(isEnabled: Bool) {
        toggleButtonEnablement(button: clearTextButton, isEnabled: isEnabled)
    }
    
    func togglePostTweetButtonEnablement(isEnabled: Bool) {
        toggleButtonEnablement(button: postTweetButton, isEnabled: isEnabled)
    }
    
    func clearText() {
        tweetCounterView.clearText()
    }
    
    func copyTextToClipboard(textToCopy: String?) {
        UIPasteboard.general.string = textToCopy
    }
    
    func showErrorToastWith(dataModel: ToastDataModel) {
        let toast = Toast()
        let uiModel = ToastUIModel(viewToShowToast: view,
                                   backgroundColor: UIColor(hexString: "#202A44"),
                                   foregroundColor: .white,
                                   verticalConstraintConstant: nil)
        toast.configure(uiModel: uiModel)
        toast.configure(dataModel: dataModel)
    }
    
    func showSuccessToastWith(dataModel: ToastDataModel) {
        let toast = Toast()
        let uiModel = ToastUIModel(viewToShowToast: view,
                                   backgroundColor: UIColor(hexString: "#4BB543"),
                                   foregroundColor: .white,
                                   verticalConstraintConstant: nil)
        toast.configure(uiModel: uiModel)
        toast.configure(dataModel: dataModel)
    }
}
