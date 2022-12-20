//
//  AppDelegate.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 28.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.pathDirectory()
        // Override point for customization after application launch.
        if UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path) == nil {
            let image = UIImage(named: "nightMountain.jpeg")
            image?.saveImageToFile()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - Path Directory

extension AppDelegate {
    
    fileprivate func pathDirectory() {
        let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let p = path[path.count - 1]
    }
}

