//
//  SubsectionCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 30.08.2022.
//

import UIKit

class SubsectionAllSongsCell: UICollectionViewCell {
    var listSongs: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createListSongs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createListSongs() {
        self.listSongs = UITableView()
        self.listSongs.backgroundColor = .clear
        self.listSongs.tag = 1
        self.listSongs.estimatedSectionHeaderHeight = 0
        self.contentView.addSubview(self.listSongs)
    }
}
