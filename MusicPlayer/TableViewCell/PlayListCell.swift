//
//  PlayListCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 03.10.2022.
//

import UIKit

class PlayListCell: UITableViewCell{
    var labelName: UILabel!
    var imgView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createImgView()
        self.createLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createImgView() {
        self.imgView = UIImageView()
        self.imgView.frame.size = CGSize(width: SongCell.height - CGFloat.offset * 2, height: SongCell.height - CGFloat.offset * 2)
        self.imgView.frame.origin.x = CGFloat.offset
        self.imgView.frame.origin.y = CGFloat.offset
        self.imgView.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.4)
//        self.imgView.image = UIImage.init(systemName: "music.note")
        
        let imageNote = "music.note".getSymbol(pointSize: self.imgView.frame.width, weight: .light)
        self.imgView.image = imageNote
        self.imgView.contentMode = .scaleAspectFit
        
        self.imgView.tintColor = UIColor.white.withAlphaComponent(0.6)
        self.contentView.addSubview(self.imgView)
    }
    
    private func createLabel() {
        self.labelName = UILabel()
        self.labelName.frame.size.width = UIScreen.main.bounds.width - self.imgView.frame.width - CGFloat.offset * 3
        self.labelName.frame.size.height = SongCell.height * 0.5
        self.labelName.frame.origin.x = self.imgView.frame.origin.x + self.imgView.frame.width + CGFloat.offset
        self.labelName.center.y = SongCell.height / 2
        self.labelName.text = "name Playlist"
        self.labelName.textColor = .white
        self.labelName.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.055, weight: .init(rawValue: UIScreen.main.bounds.width * 0.000535044))
        self.contentView.addSubview(self.labelName)
    }
    
}
