//
//  ChooseBackgroundImageCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 21.09.2022.
//

import UIKit

class ChooseBackgroundImageCell: UICollectionViewCell {
    var imgVeiw: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imgVeiw = UIImageView()
        self.imgVeiw.contentMode = .scaleAspectFill
        self.imgVeiw.backgroundColor = .systemGray2
        self.imgVeiw.clipsToBounds = true
        self.contentView.addSubview(self.imgVeiw)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
