//
//  SubsectionPlaylistCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 13.09.2022.
//

import UIKit

class SubsectionPlaylistCell: UICollectionViewCell {
    var tablePlaylist: UITableView!
    static var nameCellTableView: String!


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createTablePlaylist()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTablePlaylist() {
        self.tablePlaylist = UITableView()
        self.tablePlaylist.backgroundColor = .clear
        self.tablePlaylist.tag = 3
        self.tablePlaylist.estimatedSectionHeaderHeight = SongCell.height * 0.6
        self.tablePlaylist.sectionHeaderTopPadding = 0
        self.contentView.addSubview(self.tablePlaylist)
    }
}
