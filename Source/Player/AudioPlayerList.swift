//
//  AudioPlayerList.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/9.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class AudioPlayerList {

    var playlist: [FileManager.FileInfo]? = nil
    let audioPlayer = AudioPlayer.Sington
    
    
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: AudioPlayer.Sington)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        
    }
    
    @discardableResult
    public func play() -> AudioPlayer {
        return audioPlayer.resume()
    }
    
    @discardableResult
    public func resume() -> AudioPlayer {
        return audioPlayer.resume()
    }
    
    @discardableResult
    public func suspend() -> AudioPlayer {
        return audioPlayer.suspend()
    }
    
    @discardableResult
    public func stop() -> AudioPlayer {
        return audioPlayer.stop()
    }
    
}
