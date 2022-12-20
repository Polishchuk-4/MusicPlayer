//
//  MusicVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 28.08.2022.
//

import UIKit
import AVFoundation

enum TypeCell: Int, CaseIterable {
    case SubsectionAllSongsCell
    case SunsectionFavoriteCell
    case SubsectionPlaylistCell
}

enum StateTableView: CaseIterable {
    case normal
    case selected
}

class MusicVC: UIViewController {
    var imgViewBackground: UIImageView!
    var collectionViewChooseSection: UICollectionView!
    var collectionViewSubsection: UICollectionView!
    var buttonEdit: UIButton!
    var chooseSectionName = ["Songs", "Favorite", "Playlist"]
    var songs: [ModelSong] = []
    var favoriteSongs: [ModelSong] = []
    var currentSong: ModelSong!
    static var numberCurrentSong: Int!
    var playlists: [Playlist] = []
        
    static var stateTableView = StateTableView.normal
    
    var arrPlaylistModelSong: [ModelSong] = []
    var arrIsSelectedPlaylist: [Playlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gettingSongName()
        self.createImgViewBackground()
        self.settingNavVC()
        self.createColletionViewChooseSection()
        self.createCollectionViewSubsection()
        self.registrationCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.imgViewBackground.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        self.songs = CoreDataManager.shared.getModelSong()
        self.playlists = CoreDataManager.shared.getPlaylist()
        self.favoriteSongs = CoreDataManager.shared.getIsFavorite()
        self.reloadDataAllTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func gettingSongName() {
        if UserDefaults.standard.bool(forKey: "firstlaunch") == true {
            return
        }

        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)

        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath {
                var mySong = song.absoluteString

                if mySong.contains(".mp3") {
                    let firstString = mySong.components(separatedBy: "/")
                    mySong = firstString[firstString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    CoreDataManager.shared.createModalSong(name: mySong)
                }
            }
            UserDefaults.standard.set(true, forKey: "firstlaunch")
            UserDefaults.standard.synchronize()
        } catch {
            
        }
    }
    
    private func createImgViewBackground() {
        self.imgViewBackground = UIImageView()
        self.imgViewBackground.frame.size = UIScreen.main.bounds.size
        self.imgViewBackground.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        self.imgViewBackground.contentMode = .scaleAspectFill
        self.view.addSubview(self.imgViewBackground)
    }
    
    private func createColletionViewChooseSection() {
        let top = CGFloat.paddingView.top
        self.collectionViewChooseSection = UICollectionView(frame: CGRect(x: 0,
                                                                          y: top + self.navigationController!.navigationBar.frame.height,
                                                                         width: UIScreen.main.bounds.width,
                                                                         height: UIScreen.main.bounds.height * 0.05),
                                                           collectionViewLayout: self.createLoyoutColletionViewChooseSection())
        self.collectionViewChooseSection.backgroundColor = .clear
        self.view.addSubview(self.collectionViewChooseSection)
        self.collectionViewChooseSection.dataSource = self
        self.collectionViewChooseSection.delegate = self
        self.collectionViewChooseSection.register(ChooseSectionCell.self, forCellWithReuseIdentifier: "ChooseSectionCell")
    }
    
    private func createLoyoutColletionViewChooseSection() -> UICollectionViewFlowLayout {
        let loyout = UICollectionViewFlowLayout()
        loyout.minimumLineSpacing = 0
        loyout.scrollDirection = .horizontal
        return loyout
    }
    
    private func createCollectionViewSubsection() {
        self.collectionViewSubsection = UICollectionView(frame: CGRect(x: 0,
                                                                       y: self.collectionViewChooseSection.frame.origin.y + self.collectionViewChooseSection.frame.height,
                                                                       width: UIScreen.main.bounds.width,
                                                                       height: UIScreen.main.bounds.height - self.collectionViewChooseSection.frame.origin.y - self.collectionViewChooseSection.frame.height - self.tabBarController!.tabBar.frame.height),
                                                         collectionViewLayout: self.createLoyoutCollectionViewSubsection())
        self.collectionViewSubsection.backgroundColor = .clear
        self.view.addSubview(self.collectionViewSubsection)
        self.collectionViewSubsection.dataSource = self
        self.collectionViewSubsection.delegate = self
        self.collectionViewSubsection.isPagingEnabled = true
        self.collectionViewSubsection.register(SubsectionAllSongsCell.self, forCellWithReuseIdentifier: "SubsectionAllSongsCell")
    }
    
    private func createLoyoutCollectionViewSubsection() -> UICollectionViewFlowLayout {
        let loyout = UICollectionViewFlowLayout()
        loyout.scrollDirection = .horizontal
        loyout.sectionInset = UIEdgeInsets.zero
        loyout.minimumLineSpacing = 0
        return loyout
    }
    
    private func registrationCell() {
        self.collectionViewChooseSection.register(ChooseSectionCell.self, forCellWithReuseIdentifier: "ChooseSectionCell")
        self.collectionViewSubsection.register(SubsectionAllSongsCell.self, forCellWithReuseIdentifier: "SubsectionAllSongsCell")
        self.collectionViewSubsection.register(SubsectionFavoriteCell.self, forCellWithReuseIdentifier: "SunsectionFavoriteCell")
        self.collectionViewSubsection.register(SubsectionPlaylistCell.self, forCellWithReuseIdentifier: "SubsectionPlaylistCell")
    }
}

//MARK: - Popover -
extension MusicVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

//MARK: - UICollectionViewDelegateFlowLayout -
extension MusicVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewChooseSection {
            return CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height * 0.05)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.collectionViewChooseSection.frame.origin.y - self.collectionViewChooseSection.frame.height - self.tabBarController!.tabBar.frame.height)
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate -
extension MusicVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chooseSectionName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionViewChooseSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseSectionCell", for: indexPath) as! ChooseSectionCell
            cell.label.frame = cell.bounds
            let objc = self.chooseSectionName[indexPath.row]
            cell.label.text = objc
            if objc == UserDefaultsManager.shared.isSelecte_dChooseSectionCell {
                cell.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
            } else {
                cell.backgroundColor = .clear
            }
            return cell
        } else {
            guard let typeCell = TypeCell.init(rawValue: indexPath.row) else { fatalError() }
            switch typeCell {
            case .SubsectionAllSongsCell:
                return self.createSubsectionAllSongsCell(collectinView: collectionView, indexPath: indexPath)
            case .SunsectionFavoriteCell:
                return self.createSubsectionFavoriteCell(collectinView: collectionView, indexPath: indexPath)
            case .SubsectionPlaylistCell:
                return self.createSubsectionPlaylistCell(collectinView: collectionView, indexPath: indexPath)
            }
        }
    }
    
    private func createSubsectionAllSongsCell(collectinView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "SubsectionAllSongsCell", for: indexPath) as! SubsectionAllSongsCell
        cell.listSongs.frame.size = self.collectionViewSubsection.frame.size
        cell.listSongs.dataSource = self
        cell.listSongs.delegate = self
        cell.listSongs.reloadData()
        return cell
    }
    
    private func createSubsectionFavoriteCell(collectinView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "SunsectionFavoriteCell", for: indexPath) as! SubsectionFavoriteCell
        cell.listFavoriteSongs.frame.size = self.collectionViewSubsection.frame.size
        cell.listFavoriteSongs.dataSource = self
        cell.listFavoriteSongs.delegate = self
        cell.listFavoriteSongs.reloadData()
        return cell
    }
    
    private func createSubsectionPlaylistCell(collectinView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "SubsectionPlaylistCell", for: indexPath) as! SubsectionPlaylistCell
        cell.tablePlaylist.frame.size = self.collectionViewSubsection.frame.size
        cell.tablePlaylist.dataSource = self
        cell.tablePlaylist.delegate = self
        cell.tablePlaylist.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionViewChooseSection {
            
            if MusicVC.stateTableView == .selected {
                 return
            }
            self.collectionViewSubsection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            let objc = self.chooseSectionName[indexPath.row]
            UserDefaultsManager.shared.isSelecte_dChooseSectionCell = objc
            collectionView.reloadData()
            
        } else if collectionView == self.collectionViewSubsection {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cells = collectionViewSubsection.visibleCells
        let cell = cells.first
        
        var ta_g = 0
        
        if cell is SubsectionAllSongsCell {
            ta_g = (cell as! SubsectionAllSongsCell).listSongs.tag
        }
        
        if cell is SubsectionFavoriteCell {
            ta_g = (cell as! SubsectionFavoriteCell).listFavoriteSongs.tag
        }
        
        if cell is SubsectionPlaylistCell {
            ta_g = (cell as! SubsectionPlaylistCell).tablePlaylist.tag
        }
        
        if ta_g == 0 {
            return
        }
        let objc = self.chooseSectionName[ta_g - 1]
        UserDefaultsManager.shared.isSelecte_dChooseSectionCell = objc
        
        self.collectionViewChooseSection.reloadData()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate -
extension MusicVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return self.songs.count
        } else if tableView.tag == 2 {
            return self.favoriteSongs.count
        } else {
            return self.playlists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 || tableView.tag == 2 {
            let idCellAllSong = "allSongCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: idCellAllSong) as? SongCell
            if cell == nil {
                cell = SongCell.init(style: .default, reuseIdentifier: idCellAllSong)
                cell?.selectionStyle = .none
            }
            var modelSong: ModelSong!

            if tableView.tag == 1 {
                modelSong = self.songs[indexPath.row]
            } else if tableView.tag == 2 {
                modelSong = self.favoriteSongs[indexPath.row]
            }
                        
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
        } else {
            let idCellPlayListCell = "PlayListCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: idCellPlayListCell) as? PlayListCell
            if cell == nil {
                cell = PlayListCell.init(style: .default, reuseIdentifier: idCellPlayListCell)
                cell?.selectionStyle = .none
            }
            
            let playlist = self.playlists[indexPath.row]
            cell?.labelName.text = playlist.name
            if playlist.isSelected == false {
                cell?.backgroundColor = .clear
            } else {
                cell?.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCell.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 3 {
            return 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 3 {
            return tableView.sectionHeaderHeight
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 3 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: SongCell.height * 0.6))
            header.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)

            let label = UILabel()
            label.frame.size.width = header.frame.width * 0.7
            label.frame.size.height = header.frame.height
            label.frame.origin.x = CGFloat.offset
            label.center.y = header.frame.height / 2
            label.text = "Playlist (\(self.playlists.count))"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.055, weight: .init(rawValue: UIScreen.main.bounds.width * 0.000535044))
            label.textAlignment = .left
            header.addSubview(label)
            
            let button = UIButton()
            button.frame.size.width = header.frame.height * 0.6
            button.frame.size.height = header.frame.height * 0.6
            button.frame.origin.x = header.frame.width - button.frame.width - CGFloat.offset
            button.center.y = header.frame.height / 2
            let image = "plus".getSymbol(pointSize: header.frame.height, weight: .medium)
            button.setImage(image, for: .normal)
            button.tintColor = .white
            header.addSubview(button)
            button.addTarget(self, action: #selector(addCellPlaylist), for: .touchUpInside)
            
            return header
        } else {
            return UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    @objc func addCellPlaylist() {
        let vie_w = ViewAddCellPlaylist(frame: .zero)
        vie_w.myDelegate = self
        self.view.addSubview(vie_w)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if MusicVC.stateTableView == .normal && tableView.tag == 1 || MusicVC.stateTableView == .normal && tableView.tag == 2 {
            if tableView.tag == 1 || tableView.tag == 2 {
                var modelSong: ModelSong!
                if tableView.tag == 1 {
                    modelSong = self.songs[indexPath.row]
                    PlaySongVC.shared.songs = self.songs
                    MusicVC.numberCurrentSong = indexPath.row
                } else if tableView.tag == 2 {
                    modelSong = self.favoriteSongs[indexPath.row]
                    PlaySongVC.shared.songs = self.favoriteSongs
                    MusicVC.numberCurrentSong = indexPath.row
                }
                
                self.songs.forEach { song in
                    song.isPlaying = false
                }
                
                self.favoriteSongs.forEach { song in
                    song.isPlaying = false
                }
                
                modelSong.isPlaying = true
                CoreDataManager.shared.saveContext()
                
                self.reloadDataAllTableView()
                
                PlaySongVC.shared.startNewSong()
                PlaySongVC.shared.modalPresentationStyle = .fullScreen
                PlaySongVC.shared.myDelegate = self
                self.present(PlaySongVC.shared, animated: true)
                
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
            
        } else if MusicVC.stateTableView == .selected && tableView.tag == 1 || MusicVC.stateTableView == .selected && tableView.tag == 2 {
            
            var modelSong: ModelSong!
                        
            if tableView.tag == 1 {
                
                modelSong = self.songs[indexPath.row]
                
            } else if tableView.tag == 2 {
                
                modelSong = self.favoriteSongs[indexPath.row]
                
            }
                        
            if self.arrPlaylistModelSong.contains(modelSong) {
                for i in 0 ..< self.arrPlaylistModelSong.count {
                    if self.arrPlaylistModelSong[i] === modelSong {
                        self.arrPlaylistModelSong.remove(at: i)
                        modelSong.isSelected = false
                        break
                    }
                }
            } else {
                self.arrPlaylistModelSong.append(modelSong)
                modelSong.isSelected = true
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        } else if MusicVC.stateTableView == .normal && tableView.tag == 3 {
            let vc = SongsFromPlaylistVC()
            let playList = self.playlists[indexPath.row]
            vc.songs = playList.modelsSongs!.allObjects as! [ModelSong]
            CoreDataManager.shared.saveContext()
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if MusicVC.stateTableView == .selected && tableView.tag == 3 {
            
            let playlist = self.playlists[indexPath.row]
            
            if self.arrIsSelectedPlaylist.contains(playlist) == true {
                for i in 0 ..< self.arrIsSelectedPlaylist.count {
                    if self.arrIsSelectedPlaylist[i] === playlist {
                        self.arrIsSelectedPlaylist.remove(at: i)
                        playlist.isSelected = false
                        break
                    }
                }
            } else {
                self.arrIsSelectedPlaylist.append(playlist)
                playlist.isSelected = true
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if self.arrPlaylistModelSong.count == 0 && MusicVC.stateTableView == .selected && tableView.tag != 3 {
            self.reloadStateTableView()
        } else if self.arrIsSelectedPlaylist.count == 0 && MusicVC.stateTableView == .selected && tableView.tag == 3 {
            self.reloadStateTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        self.collectionViewSubsection.isScrollEnabled = false
        self.collectionViewChooseSection.isScrollEnabled = false
        
        MusicVC.stateTableView = .selected
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
        
        self.settingNavVC()
        return nil
    }
}

//MARK: - ViewAddCellPlaylistDelegate -
extension MusicVC: ViewAddCellPlaylistDelegate {
    func createPlaylist(name: String, image: UIImage?) {
        
        CoreDataManager.shared.createPlaylist(name: name, image: image)
        self.playlists = CoreDataManager.shared.getPlaylist()
        self.reloadDataAllTableView()
    }
}

//MARK: - NavigationBar -
extension MusicVC {
    
    private func settingNavVC() {
        let customView = UIView()
        customView.frame.size.height = self.navigationController!.navigationBar.frame.height
        customView.frame.size.width = self.view.frame.width
        
        let label = UILabel()
        label.frame.size.width = customView.frame.width * 0.5
        label.frame.size.height = customView.frame.height
        label.center.y = customView.center.y
        label.text = "Music Player"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: customView.frame.height * 0.73, weight: .light)
        
        self.buttonEdit = UIButton()
        self.buttonEdit.frame.size = CGSize(width: customView.frame.height * 0.63, height: customView.frame.height * 0.63)
        self.buttonEdit.frame.origin.x = customView.frame.origin.x + customView.frame.width - self.buttonEdit.frame.width * 1.5
        self.buttonEdit.center.y = customView.center.y
        let imageButtonEdit = "ellipsis".getSymbol(pointSize: self.buttonEdit.frame.height, weight: .light)
        self.buttonEdit.setImage(imageButtonEdit, for: .normal)
        self.buttonEdit.transform = CGAffineTransform(rotationAngle: 90.0 * CGFloat.pi / 180.0)
        self.buttonEdit.tintColor = .white
        self.buttonEdit.addTarget(self, action: #selector(menuEdit), for: .touchUpInside)
        
        let barButtonEdit = UIBarButtonItem(customView: self.buttonEdit)
        
        let buttonSearchSong = UIButton()
        buttonSearchSong.frame.size = buttonEdit.frame.size
        buttonSearchSong.frame.origin.x = buttonEdit.frame.origin.x - buttonSearchSong.frame.width * 1.2
        buttonSearchSong.center.y = buttonEdit.center.y
        let imageButtonSearchSong = "magnifyingglass".getSymbol(pointSize: buttonSearchSong.frame.height, weight: .light)
        buttonSearchSong.setImage(imageButtonSearchSong, for: .normal)
        buttonSearchSong.tintColor = .white
        buttonSearchSong.addTarget(self, action: #selector(searchSong), for: .touchUpInside)
        
        let barButtonSearchSong = UIBarButtonItem(customView: buttonSearchSong)
        
        let buttonCancel = UIButton()
        buttonCancel.frame.size.height = buttonEdit.frame.height
        buttonCancel.frame.size.width = buttonEdit.frame.height * 2.5
        buttonCancel.frame.origin.x = customView.frame.origin.x
        buttonCancel.frame.origin.y = buttonEdit.frame.origin.y - 10
        let image = "plus".getSymbol(pointSize: 0, weight: .medium)
        buttonCancel.setImage(image, for: .normal)
        buttonCancel.transform = CGAffineTransform(rotationAngle: 45.0 * CGFloat.pi / 180.0)
        buttonCancel.titleLabel?.font = UIFont.systemFont(ofSize: buttonCancel.frame.height / 1.3)
        buttonCancel.addTarget(self, action: #selector(cancelSelectedState), for: .touchUpInside)

        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        
        if MusicVC.stateTableView == .selected {
            customView.addSubview(buttonCancel)
            
            self.navigationItem.rightBarButtonItems = [barButtonEdit]
            appearence.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
        } else {
            customView.addSubview(label)
            self.navigationItem.rightBarButtonItems = [barButtonEdit, barButtonSearchSong]
            appearence.backgroundColor =  .clear
        }
        
        
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        self.navigationItem.titleView = customView
    }
    
    @objc private func menuEdit() {
        let popoverVC = PopoverVC()
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 200, height: LabelPopoverCell.height * 2)

        guard let presentionVC = popoverVC.popoverPresentationController else { return }
        presentionVC.delegate = self
        presentionVC.sourceView = self.buttonEdit
        presentionVC.permittedArrowDirections = .right
        presentionVC.sourceRect = CGRect(x: self.buttonEdit.bounds.midX,
                                         y: self.buttonEdit.bounds.midY,
                                         width: 0,
                                         height: 0)
        self.present(popoverVC, animated: true)
        popoverVC.myDelegate = self
    }
    
    @objc private func searchSong() {
        let vc = SearchSongVC()
        vc.songs = self.songs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func cancelSelectedState() {
        
        if UserDefaultsManager.shared.isSelecte_dChooseSectionCell == self.chooseSectionName[0] || UserDefaultsManager.shared.isSelecte_dChooseSectionCell == self.chooseSectionName[1] {
            self.arrPlaylistModelSong.removeAll()
            self.reloadStateTableView()
        } else {
            self.arrIsSelectedPlaylist.removeAll()
            self.reloadStateTableView()
        }

        self.collectionViewSubsection.isScrollEnabled = true
        self.collectionViewChooseSection.isScrollEnabled = true
    }
}

//MARK: - DelegatePopoverVC -
extension MusicVC: DelegatePopoverVC {
    func imagineView() {
        let vie_w = ViewAddSongsInPlayist(frame: .zero)
        vie_w.myDelegate = self
        self.view.addSubview(vie_w)
    }
    
    func deleteSongs() {
        if UserDefaultsManager.shared.isSelecte_dChooseSectionCell == self.chooseSectionName[0] || UserDefaultsManager.shared.isSelecte_dChooseSectionCell == self.chooseSectionName[1] {
            
            for i in 0 ..< self.arrPlaylistModelSong.count {
                let song = self.arrPlaylistModelSong[i]
                CoreDataManager.shared.delete(modelSong: song)
            }
            
            self.arrPlaylistModelSong.removeAll()
            
            self.songs = CoreDataManager.shared.getModelSong()
            self.favoriteSongs = CoreDataManager.shared.getIsFavorite()
        } else {
            for i in 0 ..< self.arrIsSelectedPlaylist.count {
                let playlist = self.arrIsSelectedPlaylist[i]
                CoreDataManager.shared.delete(playlist: playlist)
            }
            
            self.arrIsSelectedPlaylist.removeAll()
            
            self.playlists = CoreDataManager.shared.getPlaylist()
        }
        
        MusicVC.stateTableView = .normal
        self.settingNavVC()
        self.reloadDataAllTableView()

    }
}

//MARK: - DelegateViewAddSongsInPlayist -
extension MusicVC: DelegateViewAddSongsInPlayist {
    func cancelAddSongsInPlaylist() {
        reloadStateTableView()
    }
    
    func addSongsInPlaylist(indexPathRow: Int) {
        let playlist = self.playlists[indexPathRow]
        CoreDataManager.shared.addSongsInPlaylist(playList: playlist, songs: self.arrPlaylistModelSong)        
        self.reloadStateTableView()
    }
    
    private func reloadStateTableView() {
        MusicVC.stateTableView = .normal
        self.settingNavVC()
        
        self.songs.forEach { song in
            song.isSelected = false
        }
        
        self.favoriteSongs.forEach { song in
            song.isSelected = false
        }
        
        self.playlists.forEach { playlist in
            playlist.isSelected = false
        }
        
        self.reloadDataAllTableView()
    }
}

//MARK: - TableView.reloadData -
extension MusicVC {
    private func reloadDataAllTableView() {
        if let cellSubsection = self.collectionViewSubsection.cellForItem(at: .init(row: 0, section: 0)) as? SubsectionAllSongsCell {
            cellSubsection.listSongs.reloadData()
        }

        if let cellSubsectionTwo = self.collectionViewSubsection.cellForItem(at: .init(row: 1, section: 0)) as? SubsectionFavoriteCell {
            cellSubsectionTwo.listFavoriteSongs.reloadData()
        }

        if let cellSubsectionThree = self.collectionViewSubsection.cellForItem(at: .init(row: 2, section: 0)) as? SubsectionPlaylistCell {
            cellSubsectionThree.tablePlaylist.reloadData()
        }
        self.collectionViewSubsection.isScrollEnabled = true
        self.collectionViewChooseSection.isScrollEnabled = true
    }
}

//MARK: - PlaySongVCDelegate -
extension MusicVC: PlaySongVCDelegate {
    func finishPlay(song: ModelSong) {
        self.reloadDataAllTableView()
    }
}




