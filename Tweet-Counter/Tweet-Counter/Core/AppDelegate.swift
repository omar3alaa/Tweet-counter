//
//  AppDelegate.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 14/10/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let mainViewController = mainStoryboard.instantiateInitialViewController() else { return false }
        let window = UIWindow()
        setUpWindow(window, withRootViewController: mainViewController)
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
