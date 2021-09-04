//
//  HonkController.swift
//  HonkController
//
//  Created by Justin Hamilton on 9/3/21.
//

import Foundation
import AVKit

class HonkController: ObservableObject {
    var soundURL: URL? = Bundle.main.url(forResource: "honk", withExtension: "mp3")
    var soundPlayer: AVPlayer?
    
    init() {
        if let soundURL = self.soundURL {
            self.soundPlayer = AVPlayer(url: soundURL)
            
        }
    }
    
    @Published var playing = false
    
    func forceStartPlayer() {
        if let player = self.soundPlayer {
            self.playing = true
            player.pause()
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func resetPlayer() {
        if let player = self.soundPlayer {
            player.seek(to: .zero)
            self.playing = false
        }
    }
}
