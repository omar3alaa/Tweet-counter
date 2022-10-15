//
//  TweetCounterViewController.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import UIKit

class TweetCounterViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var tweetCounterView: TweetCounterView!
    @IBOutlet private weak var darkModeIcon: UIImageView!
    @IBOutlet private weak var darkModeSwitch: UISwitch!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: UIResponders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: Actions
    @IBAction func didToggleDarkMode(_ sender: Any) {
        guard let window = UIApplication.shared.windows.first else { return }
        let isDarkModeNow = traitCollection.userInterfaceStyle == .dark
        let newInterfaceStyle: UIUserInterfaceStyle = isDarkModeNow ? .light : .dark
        setupViewUpon(userInterfaceStyle: newInterfaceStyle)
        UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = newInterfaceStyle
        }, completion: nil)
    }
}

// MARK: Private helpers
private extension TweetCounterViewController {
    func setupView() {
        setupViewUpon(userInterfaceStyle: traitCollection.userInterfaceStyle)
    }
    
    func setupViewUpon(userInterfaceStyle: UIUserInterfaceStyle) {
        let isDarkMode = userInterfaceStyle == .dark
        darkModeIcon.tintColor = isDarkMode ? .white : UIColor(hexString: "#FDB813")
        darkModeSwitch.isOn = isDarkMode
    }
}
