//
//  ViewAddSongsInPlayist.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 26.10.2022.
//

import UIKit

protocol DelegateViewAddSongsInPlayist {
    func cancelAddSongsInPlaylist()
    func addSongsInPlaylist(indexPathRow: Int)
}

class ViewAddSongsInPlayist: UIView {
    var tableVie_w: UITableView!
    var playlists: [Playlist] = CoreDataManager.shared.getPlaylist()
    var buttonCancel: UIButton!
    
    var myDelegate: DelegateViewAddSongsInPlayist!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.settingView()
        self.createTableView()
        self.createButtonCancel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingView() {
        self.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 4
        self.frame.size.height = UIScreen.main.bounds.height * 0.4
        self.center.x = UIScreen.main.bounds.width / 2
        self.center.y = UIScreen.main.bounds.height / 2
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = self.frame.height * 0.05
    }
    
    private func createTableView() {
        self.tableVie_w = UITableView()
        self.tableVie_w.frame.size.width = self.frame.width
        self.tableVie_w.frame.size.height = self.frame.height - self.frame.height * 0.14
        self.tableVie_w.backgroundColor = .clear
        self.addSubview(self.tableVie_w)
        self.tableVie_w.dataSource = self
        self.tableVie_w.delegate = self
    }
    
    private func createButtonCancel() {
        self.buttonCancel = UIButton()
        self.buttonCancel.frame.size.width = self.frame.width * 0.2
        self.buttonCancel.frame.size.height = self.frame.height * 0.12
        self.buttonCancel.frame.origin.x = self.frame.origin.x + 230
        self.buttonCancel.frame.origin.y = self.frame.origin.y + 20
        self.buttonCancel.setTitle("cancel", for: .normal)
        self.buttonCancel.setTitleColor(.white, for: .normal)
        self.buttonCancel.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.width * 0.07, weight: .light)
        self.addSubview(self.buttonCancel)
        self.buttonCancel.addTarget(self, action: #selector(cancelAddSongs), for: .touchUpInside)
    }
    
    @objc private func cancelAddSongs() {
        self.myDelegate.cancelAddSongsInPlaylist()
        self.removeFromSuperview()
    }
}

extension ViewAddSongsInPlayist: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "ViewAddSongsInPlayist"
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? PlayListCell
        if cell == nil {
            cell = PlayListCell.init(style: .value1, reuseIdentifier: idCell)
        }
        cell?.selectionStyle = .none
        let playlist = self.playlists[indexPath.row]
        cell?.labelName.text = playlist.name
        cell?.backgroundColor = .clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myDelegate.addSongsInPlaylist(indexPathRow: indexPath.row)
        self.removeFromSuperview()
    }
}
