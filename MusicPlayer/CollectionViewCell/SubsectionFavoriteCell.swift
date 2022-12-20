//
//  SunsectionFolderCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 13.09.2022.
//

import UIKit

class SubsectionFavoriteCell: UICollectionViewCell {
    var listFavoriteSongs: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createListSongs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createListSongs() {
        self.listFavoriteSongs = UITableView()
        self.listFavoriteSongs.backgroundColor = .clear
        self.listFavoriteSongs.tag = 2
        self.listFavoriteSongs.estimatedSectionHeaderHeight = 0
        self.contentView.addSubview(self.listFavoriteSongs)
    }
}
