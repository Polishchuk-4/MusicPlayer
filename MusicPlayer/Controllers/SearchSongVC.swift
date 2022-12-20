//
//  SearchSongVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 17.09.2022.
//

import UIKit

class SearchSongVC: UITableViewController {
    var songs: [ModelSong] = []
    let searchControllerSong = UISearchController(searchResultsController: nil)

    var filtredSongs: [ModelSong] = []
    var searchBarIsEmpty: Bool {
        guard let text = searchControllerSong.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchControllerSong.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createImgViewBackground()
        self.settingNavVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchControllerSong.isActive = true
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
    
    private func settingNavVC() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
        
        self.searchControllerSong.searchBar.frame.size.height = 100
        self.searchControllerSong.searchResultsUpdater = self
        self.searchControllerSong.obscuresBackgroundDuringPresentation = false
        self.searchControllerSong.searchBar.placeholder = "Search song"
        self.searchControllerSong.searchBar.barTintColor = .white
        self.navigationItem.searchController = searchControllerSong
        self.definesPresentationContext = true
        self.searchControllerSong.delegate = self
        self.searchControllerSong.searchBar.delegate = self
    }
    
    @objc private func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate -
extension SearchSongVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.filtredSongs.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "SongCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? SongCell
        if cell == nil {
            cell = SongCell.init(style: .default, reuseIdentifier: idCell)
        }
        cell?.selectionStyle = .none

        var modelSong: ModelSong
        
        if self.isFiltering {
            modelSong = self.filtredSongs[indexPath.row]
        } else {
            modelSong = self.songs[indexPath.row]
        }
        
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

        cell?.labelName.text = modelSong.name
        cell?.backgroundColor = .clear
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SongCell.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlaySongVC.shared.songs = self.filtredSongs
        MusicVC.numberCurrentSong = indexPath.row
        
        let modelSong = self.songs[indexPath.row]
        self.songs.forEach { song in
            song.isPlaying = false
        }
        modelSong.isPlaying = true
        
        PlaySongVC.shared.modalPresentationStyle = .fullScreen
        self.present(PlaySongVC.shared, animated: true)
    }
}

//MARK: - UISearchResultsUpdating -
extension SearchSongVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredSongs = songs.filter({ ModelSong in
            return ModelSong.name!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBARDelegate -
extension SearchSongVC: UISearchControllerDelegate, UISearchBarDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.searchTextField.textColor = .white
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}
