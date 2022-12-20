//
//  SongsFromPlaylistVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 11.11.2022.
//

import UIKit

class SongsFromPlaylistVC: UITableViewController {
    var songs: [ModelSong] = []
    var selectedSongs: [ModelSong] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingNavBar()
        self.createImgViewBackground()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    private func createImgViewBackground() {
        let imgView = UIImageView()
        imgView.frame.size = UIScreen.main.bounds.size
        imgView.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        imgView.contentMode = .scaleAspectFill
        let vie_w = UIView()
        vie_w.frame.size = UIScreen.main.bounds.size
        vie_w.addSubview(imgView)
        self.tableView.backgroundView = vie_w
    }
    
    private func settingNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC))
    }
    
    @objc private func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SongsFromPlaylistVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "SongsFromPlaylistVC"
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? SongCell
        if cell == nil {
            cell = SongCell.init(style: .value1, reuseIdentifier: idCell)
        }
                
        cell?.selectionStyle = .none
        let modelSong = self.songs[indexPath.row]
        cell?.labelName.text = modelSong.name
        
        if modelSong.isPlaying == true {
            cell?.labelName.textColor = .systemBlue
            cell?.labelAutor.textColor = .systemBlue
            cell?.imgView.tintColor = .systemBlue
            cell?.buttonEditCell.tintColor = .systemBlue
        } else {
            cell?.labelName.textColor = .white
            cell?.labelAutor.textColor = .white
            cell?.imgView.tintColor = UIColor.white.withAlphaComponent(0.6)
            cell?.buttonEditCell.tintColor = .white
        }
        
        if modelSong.isSelected == true {
            cell?.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
        } else {
            cell?.backgroundColor = .clear
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCell.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelSong = self.songs[indexPath.row]
        
        if MusicVC.stateTableView == .normal {
            MusicVC.numberCurrentSong = indexPath.row
            PlaySongVC.shared.songs = self.songs

            self.songs.forEach { song in
                song.isPlaying = false
            }
            
            modelSong.isPlaying = true
            
            CoreDataManager.shared.saveContext()
            
            tableView.reloadData()
            PlaySongVC.shared.startNewSong()
            PlaySongVC.shared.modalPresentationStyle = .fullScreen
            self.present(PlaySongVC.shared, animated: true)
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
        } else {
            if self.songs.contains(modelSong) == true {
                for i in 0 ..< self.songs.count {
                    let song = self.songs[i]
                    if song === modelSong {
                        self.songs.remove(at: i)
                        modelSong.isSelected = false
                        break
                    }
                }
            } else {
                self.songs.append(modelSong)
                modelSong.isSelected = true
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

