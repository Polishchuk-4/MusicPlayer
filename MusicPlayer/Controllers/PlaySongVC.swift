//
//  PlaySongVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 13.09.2022.
//

import UIKit
import AVFoundation

enum ChooseNextSong: Int {
    case next
    case random
    case repea_t
}

protocol PlaySongVCDelegate {
    func finishPlay(song: ModelSong)
}

class PlaySongVC: UIViewController {
    var imgViewBackground: UIImageView!
    var buttonPlayPause: UIButton!
    var buttonNextSong: UIButton!
    var buttonPreviousSong: UIButton!
    var buttonRepeatSong: UIButton!
    var buttonRandomSong: UIButton!
    var labelNumberSong: UILabel!
    var sliderSong: UISlider!
    var buttonAddFavorite: UIButton!
    var labelNameAutorSong: UILabel!
    var labelNameSong: UILabel!
    var labelUINav: UILabel!
    var buttonCloseVC: UIButton!
    var buttonContextMenu: UIButton!
    var imageViewSong: UIImageView!
    var labelTimerPlay: UILabel!
    var labelTimerAllTime: UILabel!
    var songs: [ModelSong] = []
    
    var chooseNextSong = ChooseNextSong.init(rawValue: UserDefaultsManager.shared.chooseNextSong)
    var player = Player()
    
    static let shared = PlaySongVC()
    
    var myDelegate: PlaySongVCDelegate!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createImgViewBackground()
        self.createButtonPlayPause()
        self.createButtonNextSong()
        self.createButtonPreviousSong()
        self.createButtonRepeateSong()
        self.createButtonRandomSong()
        self.createLabelNumberSong()
        self.createSliderSong()
        self.createButtonAddFavorite()
        self.createLabelNameAutorSong()
        self.createLabelNameSong()
        self.createlabelUINav()
        self.createCloseVC()
        self.createContextMenu()
        self.createImageViewSong()
        self.createLabelTimerPlay()
        self.createLabelTimerAllTime()
        
        self.player.myDelegate = self
        
        self.startNewSong()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgViewBackground.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        
        self.startNewSong()
    }
    
    private func createImgViewBackground() {
        self.imgViewBackground = UIImageView()
        self.imgViewBackground.frame.size = UIScreen.main.bounds.size
        self.imgViewBackground.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        self.imgViewBackground.contentMode = .scaleAspectFill
        self.view.addSubview(self.imgViewBackground)
    }
    
    func startNewSong() {
        if self.buttonRepeatSong == nil {
            return
        }
        let song = self.songs[MusicVC.numberCurrentSong]
        self.songs.forEach { modelSong in
            modelSong.isPlaying = false
        }
        song.isPlaying = true
        self.player.playThis(modelSong: song)
        self.settingButtonsState()
        self.settingPlayer()
        self.labelNumberSong.text = "\(MusicVC.numberCurrentSong + 1)/\(self.songs.count)"
        self.labelNameSong.text = "\(song.name!)"
        self.changeMaximumValueSlider()
        self.isImageButton()
        self.viewButtonPlayPause()
        
    }
    
    private func createButtonPlayPause() {
        self.buttonPlayPause = UIButton()
        self.buttonPlayPause.frame.size = CGSize(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.2)
        self.buttonPlayPause.center.x = UIScreen.main.bounds.width * 0.5
        self.buttonPlayPause.center.y = UIScreen.main.bounds.height * 0.87
        self.view.addSubview(self.buttonPlayPause)
        let image = "pause.circle".getSymbol(pointSize: self.buttonPlayPause.frame.width, weight: .thin)
        self.buttonPlayPause.setImage(image, for: .normal)
        self.buttonPlayPause.tintColor = .white
        self.buttonPlayPause.addTarget(self, action: #selector(stopStartSong), for: .touchUpInside)
    }
    
    @objc private func stopStartSong() {
        if self.player.getState() == false {
            self.player.playSong()
        } else {
            self.player.stopSong()
        }
        self.viewButtonPlayPause()
    }
    
    func viewButtonPlayPause() {
        if self.player.getState() == false {
            let image = "play.circle".getSymbol(pointSize: self.buttonPlayPause.frame.width, weight: .thin)
            self.buttonPlayPause.setImage(image, for: .normal)
        } else {
            let image = "pause.circle".getSymbol(pointSize: self.buttonPlayPause.frame.width, weight: .thin)
            self.buttonPlayPause.setImage(image, for: .normal)
        }
    }
    
    private func createButtonNextSong() {
        self.buttonNextSong = UIButton()
        self.buttonNextSong.frame.size.width = self.buttonPlayPause.frame.width * 0.4
        self.buttonNextSong.frame.size.height = self.buttonPlayPause.frame.height * 0.4
        self.buttonNextSong.center.x = self.buttonPlayPause.center.x + self.buttonPlayPause.frame.width * 0.5 + CGFloat.offset * 3.2
        self.buttonNextSong.center.y = self.buttonPlayPause.center.y
        let image = "forward.end".getSymbol(pointSize: self.buttonNextSong.frame.width, weight: .light)
        self.buttonNextSong.setImage(image, for: .normal)
        self.buttonNextSong.tintColor = .white
        self.view.addSubview(self.buttonNextSong)
        self.buttonNextSong.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
    }
    
    @objc private func nextSong() {
        
        if MusicVC.numberCurrentSong == self.songs.count - 1 {
            return
        } else {
            self.player.playThis(modelSong: self.songs[MusicVC.numberCurrentSong + 1])
            MusicVC.numberCurrentSong += 1
            let image = "pause.circle".getSymbol(pointSize: self.buttonPlayPause.frame.width, weight: .thin)
            self.buttonPlayPause.setImage(image, for: .normal)
        }
        startNewSong()
    }
    
    private func createButtonPreviousSong() {
        self.buttonPreviousSong = UIButton()
        self.buttonPreviousSong.frame.size = self.buttonNextSong.frame.size
        self.buttonPreviousSong.center.x = self.buttonPlayPause.center.x - self.buttonPlayPause.frame.width * 0.5 - CGFloat.offset * 3.2
        self.buttonPreviousSong.center.y = self.buttonPlayPause.center.y
        let image = "backward.end".getSymbol(pointSize: self.buttonPreviousSong.frame.width, weight: .light)
        self.buttonPreviousSong.setImage(image, for: .normal)
        self.buttonPreviousSong.tintColor = .white
        self.view.addSubview(self.buttonPreviousSong)
        self.buttonPreviousSong.addTarget(self, action: #selector(previousSong), for: .touchUpInside)
    }
    
    @objc private func previousSong() {
        if MusicVC.numberCurrentSong == 0 {
            return
        } else {
            self.player.playThis(modelSong: self.songs[MusicVC.numberCurrentSong - 1])
            MusicVC.numberCurrentSong -= 1
            let image = "pause.circle".getSymbol(pointSize: self.buttonPlayPause.frame.width, weight: .thin)
            self.buttonPlayPause.setImage(image, for: .normal)
        }
        self.startNewSong()
    }
    
    private func createButtonRepeateSong() {
        self.buttonRepeatSong = UIButton()
        self.buttonRepeatSong.frame.size.width = self.buttonPreviousSong.frame.size.width * 1.1
        self.buttonRepeatSong.frame.size.height = self.buttonPreviousSong.frame.size.height * 1.1
        self.buttonRepeatSong.frame.origin.x = CGFloat.offset
        self.buttonRepeatSong.center.y = self.buttonPreviousSong.center.y
        let image = "repeat.1".getSymbol(pointSize: self.buttonRepeatSong.frame.width, weight: .light)
        self.buttonRepeatSong.setImage(image, for: .normal)
        self.buttonRepeatSong.tintColor = .white
        self.view.addSubview(self.buttonRepeatSong)
        self.buttonRepeatSong.addTarget(self, action: #selector(repeatCurrentSong), for: .touchUpInside)
    }
    
    @objc private func repeatCurrentSong() {
        
        if self.chooseNextSong == .repea_t {
            self.chooseNextSong = .next
            
        } else {
            self.chooseNextSong = .repea_t
        }
        UserDefaultsManager.shared.chooseNextSong = self.chooseNextSong!.rawValue
        self.settingButtonsState()
    }
    
    private func settingButtonsState() {
        switch self.chooseNextSong {
        case .next:
            self.buttonRepeatSong.tintColor = .systemGray4.withAlphaComponent(0.5)
            self.buttonRandomSong.tintColor = .systemGray4.withAlphaComponent(0.5)
        case .random:
            self.buttonRandomSong.tintColor = .white
            self.buttonRepeatSong.tintColor = .systemGray4.withAlphaComponent(0.5)
        case .repea_t:
            self.buttonRandomSong.tintColor = .systemGray4.withAlphaComponent(0.5)
            self.buttonRepeatSong.tintColor = .white
        default: break
        }
    }
    
    private func createButtonRandomSong() {
        self.buttonRandomSong = UIButton()
        self.buttonRandomSong.frame.size = self.buttonRepeatSong.frame.size
        self.buttonRandomSong.frame.origin.x = UIScreen.main.bounds.width - self.buttonRandomSong.frame.width - CGFloat.offset
        self.buttonRandomSong.center.y = self.buttonRepeatSong.center.y
        let image = "shuffle".getSymbol(pointSize: self.buttonRandomSong.frame.width, weight: .light)
        self.buttonRandomSong.tintColor = .white
        self.buttonRandomSong.contentMode = .scaleAspectFill
        self.buttonRandomSong.setImage(image, for: .normal)
        self.view.addSubview(self.buttonRandomSong)
        self.buttonRandomSong.addTarget(self, action: #selector(randomCurrentSong), for: .touchUpInside)
    }
    
    @objc private func randomCurrentSong() {
        
        if self.chooseNextSong == .random {
            self.chooseNextSong = .next
        } else {
            self.chooseNextSong = .random
        }
        UserDefaultsManager.shared.chooseNextSong = self.chooseNextSong!.rawValue
        self.settingButtonsState()
    }
    
    private func createLabelNumberSong() {
        self.labelNumberSong = UILabel()
        self.labelNumberSong.frame.size.width = UIScreen.main.bounds.width * 0.2
        self.labelNumberSong.frame.size.height = UIScreen.main.bounds.width * 0.045
        self.labelNumberSong.center.x = self.buttonPlayPause.center.x
        self.labelNumberSong.center.y = UIScreen.main.bounds.height - ((UIScreen.main.bounds.height - self.buttonPlayPause.frame.origin.y - self.buttonPlayPause.frame.height) / 1.3)
        self.labelNumberSong.textAlignment = .center
        self.labelNumberSong.font = UIFont.systemFont(ofSize: self.labelNumberSong.frame.height, weight: .light)
        self.labelNumberSong.textColor = .systemGray4
        self.view.addSubview(self.labelNumberSong)
    }
    
    private func createSliderSong() {
        self.sliderSong = UISlider()
        self.sliderSong.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 1.8
        self.sliderSong.frame.size.height = UIScreen.main.bounds.width * 0.1
        self.sliderSong.frame.origin.x = CGFloat.offset * 0.9
        self.sliderSong.center.y = self.buttonPlayPause.center.y - self.buttonPlayPause.frame.width * 0.8
        self.sliderSong.tintColor = .systemBlue
        
        self.sliderSong.minimumValue = 0.0
        self.sliderSong.maximumValue = Float(self.player.getDuration())
        
        self.view.addSubview(self.sliderSong)
        self.sliderSong.addTarget(self, action: #selector(changeValueSlider), for: .valueChanged)
        self.sliderSong.addTarget(self, action: #selector(endDragSlider), for: .touchUpInside)
    }
    
    @objc private func changeValueSlider() {
        self.player.stopSong()
        self.player.setCurrentTime(value: self.sliderSong.value)
        self.changeCurrentTimeSongAndValueSlider()
    }
    
    @objc func endDragSlider() {
        self.player.playSong()
    }

    private func changeMaximumValueSlider() {
        self.sliderSong.maximumValue = Float(self.player.getDuration())
        
        let durationTime = Int(self.player.getDuration())
        let durationMinutes = Int(durationTime / 60)
        let durationSeconds = durationTime - durationMinutes * 60
        
        var zeroSecondDuration = ""
        if durationSeconds < 10 {
            zeroSecondDuration = "0\(durationSeconds)"
        } else {
            zeroSecondDuration = "\(durationSeconds)"
        }
        self.labelTimerAllTime.text = "\(durationMinutes):\(zeroSecondDuration)"
    }
    
    private func changeCurrentTimeSongAndValueSlider() {
        self.sliderSong.value = Float(self.player.getCurrentTime())
        let currentTime = Int(self.sliderSong.value)
        let minutes = Int(currentTime / 60)
        let seconds = currentTime - minutes * 60
        
        var zeroSecond = ""
        if seconds < 10 {
            zeroSecond = "0\(seconds)"
        } else {
            zeroSecond = "\(seconds)"
        }
        self.labelTimerPlay.text = "\(minutes):\(zeroSecond)"
    }
    
    private func createButtonAddFavorite() {
        self.buttonAddFavorite = UIButton()
        self.buttonAddFavorite.frame.size.width = UIScreen.main.bounds.width * 0.08
        self.buttonAddFavorite.frame.size.height = UIScreen.main.bounds.width * 0.08
        self.buttonAddFavorite.frame.origin.x = UIScreen.main.bounds.width - self.buttonAddFavorite.frame.width - CGFloat.offset
        self.buttonAddFavorite.frame.origin.y = self.sliderSong.frame.origin.y - self.buttonAddFavorite.frame.height - CGFloat.offset * 1.5
        let image = "heart".getSymbol(pointSize: self.buttonAddFavorite.frame.width, weight: .light)
        self.buttonAddFavorite.tintColor = .white
        self.buttonAddFavorite.setImage(image, for: .normal)
        self.view.addSubview(self.buttonAddFavorite)
        self.buttonAddFavorite.addTarget(self, action: #selector(addFavoriteSong(button:)), for: .touchUpInside)
        self.isImageButton()
    }
    
    @objc private func addFavoriteSong(button: UIButton) {
        let song = self.songs[MusicVC.numberCurrentSong]
        if song.isFavorite == false {
            song.isFavorite = true
        } else {
            song.isFavorite = false
        }
        self.isImageButton()
        CoreDataManager.shared.saveContext()
    }
    
    private func isImageButton() {
        let song = self.songs[MusicVC.numberCurrentSong]
        if song.isFavorite == false {
            let image = "heart".getSymbol(pointSize: self.buttonAddFavorite.frame.width, weight: .light)
            self.buttonAddFavorite.setImage(image, for: .normal)
        } else {
            let image = "heart.fill".getSymbol(pointSize: self.buttonAddFavorite.frame.width, weight: .light)
            self.buttonAddFavorite.setImage(image, for: .normal)
        }
        CoreDataManager.shared.saveContext()
    }
    
    private func createLabelNameAutorSong() {
        self.labelNameAutorSong = UILabel()
        self.labelNameAutorSong.frame.size.width = UIScreen.main.bounds.width - self.buttonAddFavorite.frame.width - CGFloat.offset * 3
        self.labelNameAutorSong.frame.size.height = UIScreen.main.bounds.height * 0.02
        self.labelNameAutorSong.frame.origin.x = CGFloat.offset
        self.labelNameAutorSong.frame.origin.y = self.sliderSong.frame.origin.y - self.labelNameAutorSong.frame.height - CGFloat.offset
        self.labelNameAutorSong.text = "<Autor>"
        self.labelNameAutorSong.textAlignment = .left
        self.labelNameAutorSong.textColor = .systemGray4
        self.labelNameAutorSong.font = UIFont.systemFont(ofSize: self.labelNameAutorSong.frame.height, weight: .light)
        self.view.addSubview(self.labelNameAutorSong)
    }
    
    private func createLabelNameSong() {
        self.labelNameSong = UILabel()
        self.labelNameSong.frame.size.width = self.labelNameAutorSong.frame.width
        self.labelNameSong.frame.size.height = self.labelNameAutorSong.frame.height * 1.8
        self.labelNameSong.frame.origin.x = CGFloat.offset
        self.labelNameSong.frame.origin.y = self.labelNameAutorSong.frame.origin.y - self.labelNameSong.frame.height - CGFloat.offset
        self.labelNameSong.textColor = .white
        self.labelNameSong.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.07, weight: .init(rawValue: UIScreen.main.bounds.width * 0.0005350))
        self.view.addSubview(self.labelNameSong)
    }
    
    private func createlabelUINav() {
        self.labelUINav = UILabel()
        self.labelUINav.frame.size.width = UIScreen.main.bounds.width * 0.8
        self.labelUINav.frame.size.height = UIScreen.main.bounds.width * 0.1
        self.labelUINav.center.x = UIScreen.main.bounds.width * 0.5
        self.labelUINav.frame.origin.y = UIScreen.main.bounds.height * 0.05
        self.labelUINav.textAlignment = .center
        self.labelUINav.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.065)
        self.labelUINav.textColor = .white
        self.labelUINav.text = "Location song"
        self.view.addSubview(self.labelUINav)
    }
    
    private func createCloseVC() {
        self.buttonCloseVC = UIButton()
        self.buttonCloseVC.frame.size.width = UIScreen.main.bounds.width * 0.1
        self.buttonCloseVC.frame.size.height = UIScreen.main.bounds.width * 0.1
        self.buttonCloseVC.center.y = self.labelUINav.center.y
        let image = "chevron.down".getSymbol(pointSize: self.buttonCloseVC.frame.width / 2, weight: .medium)
        self.buttonCloseVC.setImage(image, for: .normal)
        self.buttonCloseVC.tintColor = .white
        self.view.addSubview(self.buttonCloseVC)
        self.buttonCloseVC.addTarget(self, action: #selector(closeThisVC), for: .touchUpInside)
    }
    
    @objc private func closeThisVC() {
        self.dismiss(animated: true)
    }
    
    private func createContextMenu() {
        self.buttonContextMenu = UIButton()
        self.buttonContextMenu.frame.size = self.buttonCloseVC.frame.size
        self.buttonContextMenu.frame.origin.x = self.labelUINav.frame.origin.x + self.labelUINav.frame.width
        self.buttonContextMenu.center.y = self.labelUINav.center.y
        let image = "ellipsis".getSymbol(pointSize: self.buttonContextMenu.frame.width * 0.5, weight: .medium)
        self.buttonContextMenu.setImage(image, for: .normal)
        self.buttonContextMenu.transform = CGAffineTransform(rotationAngle: 90.0 * CGFloat.pi / 180.0)
        self.buttonContextMenu.tintColor = .white
        self.buttonContextMenu.backgroundColor = .clear
        self.view.addSubview(self.buttonContextMenu)
    }
    
    private func createImageViewSong() {
        self.imageViewSong = UIImageView()
        self.imageViewSong.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 2
        
        self.imageViewSong.frame.size.height = UIScreen.main.bounds.height - self.labelUINav.frame.origin.y - self.labelUINav.frame.height - (UIScreen.main.bounds.height - self.labelNameSong.frame.origin.y) - CGFloat.offset * 2
        
        self.imageViewSong.frame.origin.x = CGFloat.offset
        self.imageViewSong.frame.origin.y = self.labelUINav.frame.origin.y + self.labelUINav.frame.height + CGFloat.offset
        self.imageViewSong.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.4)
        let image = "music.note".getSymbol(pointSize: self.imageViewSong.frame.width / 5, weight: .medium)
        self.imageViewSong.image = image
        self.imageViewSong.contentMode = .scaleAspectFill
        self.imageViewSong.tintColor = UIColor.white.withAlphaComponent(0.6)
        self.view.addSubview(self.imageViewSong)
        
        let swipeDown = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeSong(swipe:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.imageViewSong.addGestureRecognizer(swipeDown)
        
        let swipeleft = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeSong(swipe:)))
        swipeleft.direction = UISwipeGestureRecognizer.Direction.left
        self.imageViewSong.addGestureRecognizer(swipeleft)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeSong(swipe:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.imageViewSong.addGestureRecognizer(swipeRight)

        self.imageViewSong.isUserInteractionEnabled = true
    }
    
    @objc func swipeSong(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .down {
            self.closeThisVC()
        } else if swipe.direction == .left {
            self.nextSong()
        } else if swipe.direction == .right {
            self.previousSong()
        }
    }
    
    private func createLabelTimerPlay() {
        self.labelTimerPlay = UILabel()
        self.labelTimerPlay.frame.size.width = UIScreen.main.bounds.width * 0.13
        self.labelTimerPlay.frame.size.height = UIScreen.main.bounds.width * 0.05
        self.labelTimerPlay.frame.origin.x = CGFloat.offset
        self.labelTimerPlay.frame.origin.y = self.sliderSong.frame.origin.y + self.sliderSong.frame.height * 0.8
        self.labelTimerPlay.text = "0:00"
        self.labelTimerPlay.textColor = .white
        self.labelTimerPlay.textAlignment = .left
        self.labelTimerPlay.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.041, weight: .medium)
        self.view.addSubview(self.labelTimerPlay)
    }
    
    private func createLabelTimerAllTime() {
        self.labelTimerAllTime = UILabel()
        self.labelTimerAllTime.frame.size = self.labelTimerPlay.frame.size
        self.labelTimerAllTime.frame.origin.x = UIScreen.main.bounds.width - self.labelTimerAllTime.frame.width - CGFloat.offset
        self.labelTimerAllTime.center.y = self.labelTimerPlay.center.y
        self.labelTimerAllTime.text = "0:00"
        self.labelTimerAllTime.textColor = .white
        self.labelTimerAllTime.textAlignment = .right
        self.labelTimerAllTime.font = self.labelTimerPlay.font
        self.view.addSubview(self.labelTimerAllTime)
    }
    
    private func settingPlayer() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.changeCurrentTimeSongAndValueSlider()
        }
    }
    
    private func reapeteSong() {
        self.startNewSong()
    }
    
    private func randomSong() {
        MusicVC.numberCurrentSong = Int.random(in: 0 ..< self.songs.count)
        self.startNewSong()
    }
    
}

//MARK: - PlayerDelegate -
extension PlaySongVC: PlayerDelegate {
    func finishPlay() {
        if MusicVC.numberCurrentSong == self.songs.count - 1 && self.chooseNextSong == .next {
            
            self.viewButtonPlayPause()
        } else {
            switch chooseNextSong {
            case .next: self.nextSong()
            case .repea_t: self.reapeteSong()
            case .random: self.randomSong()
            default: break
            }
        }
        
        self.myDelegate.finishPlay(song: self.songs[MusicVC.numberCurrentSong])
    }
}


