//
//  String.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 28.08.2022.
//

import UIKit

extension String {
    func getSymbol(pointSize: CGFloat, weight: UIImage.SymbolWeight) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        let image = UIImage(systemName: self, withConfiguration: config)
        return image!
    }
}
