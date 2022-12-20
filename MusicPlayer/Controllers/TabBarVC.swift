//
//  TabBarVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 28.08.2022.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addControllers()
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func addControllers() {
        let musicVC = MusicVC()
        let musicNavVC = UINavigationController(rootViewController: musicVC)
        let musicVCImage = "music.note.list".getSymbol(pointSize: 20, weight: .light)
        musicNavVC.tabBarItem = UITabBarItem(title: "Music", image: musicVCImage, tag: 0)
        musicNavVC.navigationBar.tintColor = .white
        musicNavVC.navigationBar.barTintColor = .white
        
        
        
        let settingVC = SettingVC()
        let settingNavVC = UINavigationController(rootViewController: settingVC)
        let settingVCImage = "gear".getSymbol(pointSize: 20, weight: .light)
        settingNavVC.tabBarItem = UITabBarItem(title: "Setting", image: settingVCImage, tag: 1)
        
        self.viewControllers = [musicNavVC, settingNavVC]
    }
}
