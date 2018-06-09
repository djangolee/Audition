//
//  LibraryTableViewCell.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/7.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit
import JoUIKit
import SnapKit

class LibraryTableViewCell: UITableViewCell {
    
    var file: FileManager.FileInfo?
    
    //MARK: Subviews
    
    internal let iconImageView = UIImageView()
    internal let fileNameLable = UILabel()
    internal let describeLabel = UILabel()
    internal let playControl = PlayControl()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeProgress(_:)), name: AudioPlayer.audioPlayChangeProgressNotification, object: AudioPlayer.Sington)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeState(_:)), name: AudioPlayer.audioPlayChangeStateNotification, object: AudioPlayer.Sington)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: AudioPlayer.Sington)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func render(_ file: FileManager.FileInfo) {
        self.file = file
        iconImageView.image = file.fileIcon
        fileNameLable.text = file.name
        describeLabel.text = file.des
        
        if file == AudioPlayer.Sington.source {
            playControl.progress = CGFloat(AudioPlayer.Sington.currentTime / AudioPlayer.Sington.duration)
            playControl.playState = file == AudioPlayer.Sington.source ? .play : .pause
            playControl.isHidden = false
        } else {
            playControl.progress = 0
            playControl.playState = .pause
            playControl.isHidden = true
        }
    }
    
    @objc private func onClickPlayControl(_ sender: PlayControl) {
        guard let file = file
            else { return }
        
        if file != AudioPlayer.Sington.source {
            AudioPlayer.Sington.play(file)
        }
        
        if AudioPlayer.Sington.state == .playing {
            AudioPlayer.Sington.suspend()
        } else {
            AudioPlayer.Sington.resume()
        }
    }
    
    @objc private func audioPlayChangeProgress(_ sender: NSNotification) {
        if file == AudioPlayer.Sington.source {
            playControl.progress = CGFloat(AudioPlayer.Sington.currentTime / AudioPlayer.Sington.duration)
        }
    }
    
    @objc private func audioPlayChangeState(_ sender: NSNotification) {
        playControl.playState = (AudioPlayer.Sington.state == .playing && file == AudioPlayer.Sington.source) ? .play : .pause
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        playControl.isHidden = file != AudioPlayer.Sington.source
    }
}

//MARK: Load View

extension LibraryTableViewCell {
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        
        setupIconImageView()
        setupLabel()
        setupPlayControl()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(44)
            maker.leading.equalToSuperview().offset(18)
            maker.centerY.equalToSuperview()
        }
        
        fileNameLable.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView.snp.centerY).offset(3)
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().inset(15)
        }
        
        describeLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(fileNameLable)
            maker.top.equalTo(fileNameLable.snp.bottom).offset(2)
        }
        
        playControl.snp.updateConstraints { (maker) in
            maker.width.height.equalTo(35)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        jo.setSeparator(.bottom)
        jo.setSeparatorBottomlineCorner(JoViewSeparatorCorner(top: 0, leading: 44 + 20, bottom: 0, trailing: 0, thickness: UIScreen.main.jo.apixel), animated: true)
    }
    
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFill
        contentView.addSubview(iconImageView)
    }
    
    private func setupLabel() {
        fileNameLable.textColor = .black
        fileNameLable.font = .systemFont(ofSize: 14)
        contentView.addSubview(fileNameLable)
        
        describeLabel.textColor = .lightGray
        describeLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(describeLabel)
    }
    
    private func setupPlayControl() {
        
        playControl.addTarget(self, action: #selector(onClickPlayControl(_:)), for: .touchUpInside)
        contentView.addSubview(playControl)
    }
}
