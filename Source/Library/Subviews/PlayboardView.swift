//
//  swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/17.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class PlayboardView: UIView {
    
    enum Style {
        case fold
        case unfold
    }
    
    public var style: Style = .unfold {
        didSet { didSetStyle() }
    }
    
    private let playlist = AudioPlayerList.default
    
    public let audioTabbar = AudioTabbar()
    public let foldItem = ArrowFoldItem()
    public let coverImageView = UIImageView(image: UIImage(named: "AudioIcon"))
    public let progressView = UIProgressView()
    
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let nameLabel = UILabel()
    
    private let previousItem = UIButton()
    private let nextItem = UIButton()
    private let playItem = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeProgress(_:)), name: AudioPlayer.audioPlayChangeProgressNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeState(_:)), name: AudioPlayer.audioPlayChangeStateNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: playlist.audioPlayer)
        
        addSubview(audioTabbar)
        addSubview(coverImageView)
        addSubview(progressView)
        addSubview(foldItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onClickPrevious(_ sender: UIControl) {
        playlist.previous()
    }
    
    @objc private func onClickNext(_ sender: UIControl) {
        playlist.next()
    }
    
    @objc private func onClickPlay(_ sender: UIControl) {
        if playlist.isPlaying {
            playlist.suspend()
        } else {
            playlist.resume()
        }
    }
    
    @objc private func audioPlayChangeProgress(_ sender: NSNotification) {
        
    }
    
    @objc private func audioPlayChangeState(_ sender: NSNotification) {
        playItem.setTitle(String(playlist.isPlaying ? .pause : .play), for: .normal)
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        nameLabel.text = playlist.currentSource?.name
    }
    
}

extension PlayboardView {
    
    public func didSetStyle() {
        
        switch style {
        case .fold:
            audioTabbar.alpha = 1
            foldItem.alpha = 0
            progressView.alpha = 0.1
            currentTimeLabel.alpha = 0.1
            durationLabel.alpha = 0.1
            coverImageView.snp.remakeConstraints { maker in
                maker.edges.equalTo(audioTabbar.icon)
            }
            progressView.snp.remakeConstraints { maker in
                maker.leading.equalToSuperview().inset(25)
                maker.width.equalTo(UIScreen.main.bounds.width - 50)
                maker.top.equalTo(coverImageView.snp.bottom).offset(10)
            }
            break
        case .unfold:
            audioTabbar.alpha = 0
            foldItem.alpha = 1
            progressView.alpha = 1
            currentTimeLabel.alpha = 1
            durationLabel.alpha = 1
            let width = UIScreen.main.bounds.width - 62 * 2
            coverImageView.snp.remakeConstraints { maker in
                maker.width.height.equalTo(width)
                maker.top.leading.equalToSuperview().inset(62)
            }
            progressView.snp.remakeConstraints { maker in
                maker.leading.equalToSuperview().inset(25)
                maker.width.equalTo(UIScreen.main.bounds.width - 50)
                maker.top.equalTo(coverImageView.snp.bottom).offset(62)
            }
            break
        }
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupAudioTabbar()
        setupCover()
        setupTimeLable()
        setupItem()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        foldItem.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        currentTimeLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(progressView).offset(-2)
            maker.top.equalTo(progressView.snp.bottom).offset(10)
        }
        
        durationLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(progressView).offset(2)
            maker.top.equalTo(progressView.snp.bottom).offset(10)
        }
        
        nameLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(progressView.snp.bottom).offset(40)
            maker.width.equalToSuperview().multipliedBy(0.8)
        }
        
        playItem.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(nameLabel.snp.bottom).offset(30)
        }
        
        nextItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(playItem)
            maker.leading.equalTo(playItem.snp.trailing).offset(55)
        }
        
        previousItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(playItem)
            maker.trailing.equalTo(playItem.snp.leading).offset(-55)
        }
    }
    
    private func setupAudioTabbar() {
        audioTabbar.contentView.jo.setSeparator(.top)
        audioTabbar.frame.origin = .zero
        audioTabbar.icon.isHidden = true
    }
    
    private func setupCover() {
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 5
    }
    
    private func setupTimeLable() {
        currentTimeLabel.font = .systemFont(ofSize: 14)
        currentTimeLabel.textColor = .lightGray
        currentTimeLabel.text = "--:--"
        addSubview(currentTimeLabel)
        
        durationLabel.font = .systemFont(ofSize: 14)
        durationLabel.textColor = .lightGray
        durationLabel.text = "--:--"
        addSubview(durationLabel)
        
        nameLabel.font = .boldSystemFont(ofSize: 30)
        nameLabel.textColor = .black
        nameLabel.text = "Not Playing"
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.text = playlist.currentSource?.name ?? "Not Playing"
        addSubview(nameLabel)
    }
    
    private func setupItem() {
        previousItem.titleLabel?.font = UIFont(icon: 40)
        previousItem.setTitle(String(.previous), for: .normal)
        previousItem.setTitleColor(UIColor(white: 0.35, alpha: 1), for: .normal)
        previousItem.addTarget(self, action: #selector(onClickPrevious(_:)), for: .touchUpInside)
        addSubview(previousItem)
        
        nextItem.titleLabel?.font = UIFont(icon: 40)
        nextItem.setTitle(String(.next), for: .normal)
        nextItem.setTitleColor(UIColor(white: 0.35, alpha: 1), for: .normal)
        nextItem.addTarget(self, action: #selector(onClickNext(_:)), for: .touchUpInside)
        addSubview(nextItem)
        
        playItem.titleLabel?.font = UIFont(icon: 55)
        playItem.setTitle(String(playlist.isPlaying ? .pause : .play), for: .normal)
        playItem.setTitleColor(.black, for: .normal)
        playItem.addTarget(self, action: #selector(onClickPlay(_:)), for: .touchUpInside)
        addSubview(playItem)
    }
    
}
