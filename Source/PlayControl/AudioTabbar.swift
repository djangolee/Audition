//
//  AudioTabbar.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/8.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class AudioTabbar: UIVisualEffectView {
    
    private let playlist = AudioPlayerList.default
    
    private let icon = UIImageView(image: UIImage(named: "AudioIcon"))
    private let nameLabel = UILabel()
    private let nextItem = UIButton()
    private let playItem = UIButton()
    
    init() {
        super.init(effect: UIBlurEffect(style: .light))
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeProgress(_:)), name: AudioPlayer.audioPlayChangeProgressNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeState(_:)), name: AudioPlayer.audioPlayChangeStateNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: playlist.audioPlayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func audioPlayChangeProgress(_ sender: NSNotification) {

    }
    
    @objc private func audioPlayChangeState(_ sender: NSNotification) {
        playItem.setTitle(String(playlist.isPlaying ? .pause : .play), for: .normal)
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        nameLabel.text = playlist.currentSource?.name
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
}

extension AudioTabbar {
    
    static let TabBarHeight: CGFloat = 65
    
    override var safeAreaInsets: UIEdgeInsets {
            return UIEdgeInsets.init(top: 5, left: 25, bottom: 5, right: 25)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        invalidateIntrinsicContentSize()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = superview
            else {
                return CGSize.zero;
        }
        return CGSize(width: UIScreen.main.bounds.width, height: AudioTabbar.TabBarHeight + safeAreaInsets.bottom)
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(.zero)
    }
    
    override func jo_viewDidLoad() {
        super.jo_viewDidLoad()
        
    }

    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupIcon()
        setupNameLabel()
        setupNextItem()
        setupPlayItem()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        icon.snp.makeConstraints { maker in
            maker.width.height.equalTo(49)
            maker.top.leading.equalToSuperview().inset(safeAreaInsets)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(icon)
            maker.leading.equalTo(icon.snp.trailing).offset(10)
            maker.trailing.lessThanOrEqualTo(playItem.snp.leading).offset(-10)
        }
        nextItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(icon)
            maker.trailing.equalToSuperview().inset(safeAreaInsets)
        }
        playItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(icon)
            maker.trailing.equalTo(nextItem.snp.leading).offset(-15)
        }
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupIcon() {
        icon.clipsToBounds = true;
        icon.layer.cornerRadius = 3
        contentView.addSubview(icon)
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Not Playing"
        nameLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
    }
    
    private func setupNextItem() {
        nextItem.titleLabel?.font = UIFont(icon: 28)
        nextItem.setTitle(String(.next), for: .normal)
        nextItem.setTitleColor(.black, for: .normal)
        nextItem.addTarget(self, action: #selector(onClickNext(_:)), for: .touchUpInside)
        contentView.addSubview(nextItem)
    }
    
    private func setupPlayItem() {
        playItem.titleLabel?.font = UIFont(icon: 28)
        playItem.setTitle(String(playlist.isPlaying ? .pause : .play), for: .normal)
        playItem.setTitleColor(.black, for: .normal)
        playItem.addTarget(self, action: #selector(onClickPlay(_:)), for: .touchUpInside)
        contentView.addSubview(playItem)
    }
}
