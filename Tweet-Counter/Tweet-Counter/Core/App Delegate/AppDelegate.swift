//
//  AppDelegate.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 14/10/2022.
//

import UIKit
import TweetCounterUIComponents
import OAuthSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TweetCounterUIComponents.shared.initialize()
        let tweetCounterRootBuilder = TweetCounterRootBuilder()
        let viewController = tweetCounterRootBuilder.buildModule()
        let window = UIWindow()
        setUpWindow(window, withRootViewController: viewController)
        self.window = window
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
        if url.host == YOUR_CALLBACK_URL_HOST {
            OAuthSwift.handle(url: url)
        }
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
