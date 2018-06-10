//
//  AudioPlayerList.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/9.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

public class AudioPlayerList {
    
    public enum PlayMode {
        case shuffle
        case repeatAll
        case repeatSingle
    }
    
    static let `default` = AudioPlayerList()
    
    public let audioPlayer = AudioPlayer()
    public var playmode: PlayMode = .repeatAll
    
    private(set) var playlist: [FileManager.FileInfo]? = nil {
        didSet {
            repeatAllist = playlist ?? []
            for item in repeatAllist {
                if !shufflelist.contains(item) {
                    let at = Int.random(in: 0...shufflelist.count)
                    shufflelist.insert(item, at: at)
                }
            }
            shufflelist = shufflelist.filter { repeatAllist.contains($0) }
        }
    }
    
    private var shufflelist: [FileManager.FileInfo] = []
    private var repeatAllist: [FileManager.FileInfo] = []
    private var repeatSinglelist: [FileManager.FileInfo] = []
    
    public var currentSource: FileManager.FileInfo? {
        return audioPlayer.source
    }
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: audioPlayer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        
        if let source = audioPlayer.source {
            repeatSinglelist = [source]
        } else {
            repeatSinglelist = []
        }
        
        switch (audioPlayer.state, playmode) {
        case (.completed(let error), .repeatSingle) where error == nil:
            seek(to: 0)
        default:
            next()
        }
    }
    
    public func play(_ file: FileManager.FileInfo) {
        guard file.isSound
            else { return }
        
        playlist = playlist ?? []
        playlist?.append(file)
        play(file)
    }
    
    public func play(_ list: [FileManager.FileInfo], index: Int = 0) {
        playlist = list.filter { $0.isSound }
        if let first = playlist?.first {
            play(first)
        }
    }
    
    public func play(_ list: [FileManager.FileInfo], file: FileManager.FileInfo) {
        var temp = list
        if !temp.contains(file) {
            temp.insert(file, at: 0)
        }
        playlist = temp.filter { $0.isSound }
        play(file)
    }
    
    public func previous() {
        check(by: -1)
    }
    
    public func next() {
        check(by: 1)
    }
    
    public func resume() {
        audioPlayer.resume()
    }
    
    public func suspend() {
        audioPlayer.suspend()
    }
    
    public func stop() {
        audioPlayer.stop()
    }
    
    public func seek(to time: TimeInterval) {
        audioPlayer.seek(to:time)
    }
    
    private func paly(_ file: FileManager.FileInfo) {
        guard file.isSound
            else {
                return
        }
        repeatSinglelist = [file]
        audioPlayer.play(file)
    }
    
    private func check(by offset: Int) {
        guard let first = playlist?.first
            else {
                return
        }
        
        guard let currentSource = currentSource
            else {
                play(first)
                return
        }
        
        var list: [FileManager.FileInfo]
        switch playmode {
        case .shuffle:
            list = shufflelist
        case .repeatAll, .repeatSingle:
            list = repeatAllist
        }
        
        var index = list.startIndex
        for item in list {
            if item == currentSource {
                break
            }
            index += 1
        }
        
        index += offset
        if index >= list.count {
            index = 0
        } else if index < 0 {
            index = list.count - 1
        }
        play(list[index])
    }
}
