//
//  SongCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 13.09.2022.
//

import UIKit

class SongCell: UITableViewCell {
    var imgView: UIImageView!
    var buttonEditCell: UIButton!
    var labelName: UILabel!
    var labelAutor: UILabel!
    var editin_g: UIButton!
    static let height: CGFloat = UIScreen.main.bounds.width * 0.17 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCell() {
        self.imgView = UIImageView()
        self.imgView.frame.size = CGSize(width: SongCell.height - CGFloat.offset * 2, height: SongCell.height - CGFloat.offset * 2)
        self.imgView.frame.origin.x = CGFloat.offset
        self.imgView.frame.origin.y = CGFloat.offset
        self.imgView.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.4)
        
        let imageNote = "music.note".getSymbol(pointSize: self.imgView.frame.width, weight: .light)
        self.imgView.image = imageNote
        self.imgView.contentMode = .scaleAspectFit
        
        self.imgView.tintColor = UIColor.white.withAlphaComponent(0.6)
        self.contentView.addSubview(self.imgView)
        
        self.buttonEditCell = UIButton()
        self.buttonEditCell.frame.size = CGSize(width: SongCell.height / 2, height: SongCell.height / 2)
        self.buttonEditCell.frame.origin.x = UIScreen.main.bounds.width - self.buttonEditCell.frame.width - CGFloat.offset
        self.buttonEditCell.center.y = SongCell.height / 2
        let image = "ellipsis".getSymbol(pointSize: SongCell.height / 3, weight: .light)
        self.buttonEditCell.setImage(image, for: .normal)
        self.buttonEditCell.transform = CGAffineTransform(rotationAngle: 90.0 * CGFloat.pi / 180.0)
        self.buttonEditCell.tintColor = .white
//        self.contentView.addSubview(self.buttonEditCell)
        
        self.labelName = UILabel()
        self.labelName.frame.size.width = UIScreen.main.bounds.width - self.imgView.frame.width - self.buttonEditCell.frame.width - CGFloat.offset * 4
        self.labelName.frame.size.height = SongCell.height * 0.4
        self.labelName.frame.origin.x = self.imgView.frame.origin.x + self.imgView.frame.width + CGFloat.offset
        self.labelName.frame.origin.y = self.imgView.frame.origin.y
        self.labelName.text = "Song name"
        self.labelName.textColor = .white
        self.labelName.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.055, weight: .init(rawValue: UIScreen.main.bounds.width * 0.000535044))
        self.contentView.addSubview(self.labelName)
        
        self.labelAutor = UILabel()
        self.labelAutor.frame.size = self.labelName.frame.size
        self.labelAutor.frame.origin.x = self.labelName.frame.origin.x
        self.labelAutor.frame.origin.y = self.imgView.frame.origin.y + self.imgView.frame.height - self.labelAutor.frame.height * 0.85
        self.labelAutor.text = "<Autor>"
        self.labelAutor.textColor = UIColor.systemGray4
        self.contentView.addSubview(self.labelAutor)
    }
    
}
