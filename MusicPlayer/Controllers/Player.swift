//
//  Player.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 23.09.2022.
//

import AVFoundation

protocol PlayerDelegate {
    func finishPlay()
}

class Player: NSObject {
    private var audioPlayer = AVAudioPlayer()
    var myDelegate: PlayerDelegate!
    
    override init() {
        super.init()
        
    }
    
    func playThis(modelSong: ModelSong) {
        do {
            let audioPath = Bundle.main.path(forResource: modelSong.name, ofType: ".mp3")
            try self.audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            self.audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
    func getState() -> Bool {
        return self.audioPlayer.isPlaying
    }
    
    func getDuration() -> Double {
        return self.audioPlayer.duration
    }
    
    func setCurrentTime(value: Float) {
        self.audioPlayer.currentTime = Double(value)
    }
    
    func getCurrentTime() -> Double {
        return self.audioPlayer.currentTime
    }
    
    func stopSong() {
        self.audioPlayer.stop()
    }
    
    func playSong() {
        self.audioPlayer.play()
    }
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.myDelegate.finishPlay()
    }
}

