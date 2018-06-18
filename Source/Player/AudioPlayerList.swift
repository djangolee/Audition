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
    public var playmode: PlayMode = .repeatSingle
    
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
    
    public var state: AudioPlayer.State { return audioPlayer.state }
    public var isPlaying: Bool { return audioPlayer.isPlaying }
    public var duration: TimeInterval { return audioPlayer.duration }
    public var currentTime: TimeInterval { return audioPlayer.currentTime }
    
    public var currentSource: FileManager.FileInfo? {
        return audioPlayer.source
    }
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeState(_:)), name: AudioPlayer.audioPlayChangeStateNotification, object: audioPlayer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func audioPlayChangeState(_ sender: NSNotification) {
        switch (audioPlayer.state, playmode) {
        case (.completed(let error), .repeatSingle) where error == nil:
            seek(to: 0)
        case (.completed(_), _):
            next()
        default:
            break
        }
    }
    
    public func play(_ file: FileManager.FileInfo) {
        guard file.isSound
            else { return }

        playlist = playlist ?? []
        playlist?.append(file)
        _paly(file)
    }
    
    public func play(_ list: [FileManager.FileInfo], index: Int = 0) {
        playlist = list.filter { $0.isSound }
        if let first = playlist?.first {
            _paly(first)
        }
    }
    
    public func play(_ list: [FileManager.FileInfo], file: FileManager.FileInfo) {
        var temp = list
        if !temp.contains(file) {
            temp.insert(file, at: 0)
        }
        playlist = temp.filter { $0.isSound }
        _paly(file)
    }
    
    public func previous() {
        check(by: -1)
        resume()
    }
    
    public func next() {
        check(by: 1)
        resume()
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
    
    private func _paly(_ file: FileManager.FileInfo) {
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
                _paly(first)
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
        _paly(list[index])
    }
}
