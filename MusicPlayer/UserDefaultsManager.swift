//
//  UserDefaultsManager.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 14.09.2022.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private var nameImageBackgroundKey = "nameImageBackground"
    var nameImageBackground: String {
        get {
//            if UserDefaults.standard.string(forKey: nameImageBackgroundKey) == nil {
//                UserDefaults.standard.set("nightMountain.jpeg", forKey: nameImageBackgroundKey)
//                UserDefaults.standard.synchronize()
//            }
            return UserDefaults.standard.string(forKey: nameImageBackgroundKey)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameImageBackgroundKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var chooseNextSongKey = "chooseNextSong"
    var chooseNextSong: Int {
        get {
            return UserDefaults.standard.integer(forKey: chooseNextSongKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: chooseNextSongKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var isSelecte_dChooseSectionCellKey = "isSelecte_dChooseSectionCellKey"
    var isSelecte_dChooseSectionCell: String {
        get {
            return UserDefaults.standard.string(forKey: isSelecte_dChooseSectionCellKey) ?? "Songs"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isSelecte_dChooseSectionCellKey)
            UserDefaults.standard.synchronize()
        }
    }
}

