//
//  AppDelegate.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 14/10/2022.
//

import UIKit
import TweetCounterUIComponents

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TweetCounterUIComponents.shared.initialize()
        let tweetCounterViewController = TweetCounterViewController()
        let window = UIWindow()
        setUpWindow(window, withRootViewController: tweetCounterViewController)
        self.window = window
        return true
    }
}

private extension AppDelegate {
    func setUpWindow(_ window: UIWindow, withRootViewController rootViewController: UIViewController) {
      window.frame = UIScreen.main.bounds
      window.makeKeyAndVisible()
      window.rootViewController = rootViewController
    }
}
