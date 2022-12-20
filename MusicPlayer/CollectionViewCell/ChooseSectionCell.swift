//
//  ChooseSectionCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 30.08.2022.
//

import UIKit

class ChooseSectionCell: UICollectionViewCell {
    var label: UILabel!
    var isSelecte_d: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel() {
        self.label = UILabel()
        self.label.textColor = .white
        self.label.textAlignment = .center
        self.label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.055, weight: .init(rawValue: UIScreen.main.bounds.width * 0.000535044))
        self.contentView.addSubview(label)
    }
}
