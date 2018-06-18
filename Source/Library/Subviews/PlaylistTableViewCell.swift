//
//  PlaylistTableViewCell.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/18.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    
    var file: FileManager.FileInfo?
    
    private let selectedColor = UIColor(red: 252 / 256.0, green: 47 / 256.0, blue: 85 / 256.0, alpha: 1)
    private let playlist = AudioPlayerList.default
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: playlist.audioPlayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func render(_ file: FileManager.FileInfo) {
        self.file = file
        textLabel?.text = file.name
        textLabel?.textColor = file == AudioPlayerList.default.currentSource ? selectedColor : .black
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        textLabel?.textColor = file == AudioPlayerList.default.currentSource ? selectedColor : .black
    }

}
