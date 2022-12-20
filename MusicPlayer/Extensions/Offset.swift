//
//  Offset.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 15.11.2022.
//

// MARK: - Get Window

import UIKit

extension UIWindow {
    
    class func getWindow() -> UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window
    }
}

extension CGFloat {
    static var paddingView: (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
            guard let window = UIWindow.getWindow() else { return (0, 0, 0, 0)}
            let top = window.safeAreaInsets.top
            let bottom = window.safeAreaInsets.bottom
            let left = window.safeAreaInsets.left
            let right = window.safeAreaInsets.right
            return (top, bottom, left, right)
        }
}
