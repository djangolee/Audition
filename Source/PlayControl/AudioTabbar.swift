//
//  AudioTabbar.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/8.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class AudioTabbar: UIVisualEffectView {
    
    private let icon = UIImageView(image: UIImage(named: "AudioIcon"))
    private let nameLabel = UILabel()
    private let nextItem = UIButton()
    private let playItem = UIButton()
    
    init() {
        super.init(effect: UIBlurEffect(style: .light))
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeProgress(_:)), name: AudioPlayer.audioPlayChangeProgressNotification, object: AudioPlayer.Sington)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeState(_:)), name: AudioPlayer.audioPlayChangeStateNotification, object: AudioPlayer.Sington)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: AudioPlayer.Sington)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        invalidateIntrinsicContentSize()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: safeAreaInsets.bottom)
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(.zero)
    }
    
    @objc private func audioPlayChangeProgress(_ sender: NSNotification) {

    }
    
    @objc private func audioPlayChangeState(_ sender: NSNotification) {
        playItem.setTitle(String(AudioPlayer.Sington.isPlaying ? .pause : .play), for: .normal)
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        nameLabel.text = AudioPlayer.Sington.source?.name
    }
    
    @objc private func onClickNext(_ sender: UIControl) {
        
    }
    
    @objc private func onClickPlay(_ sender: UIControl) {
        if AudioPlayer.Sington.isPlaying {
            AudioPlayer.Sington.suspend()
        } else {
            AudioPlayer.Sington.resume()
        }
    }
}

extension AudioTabbar {
    
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
            maker.width.height.equalTo(40)
            maker.top.equalToSuperview().offset(5)
            maker.leading.equalToSuperview().offset(20)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(icon)
            maker.leading.equalTo(icon.snp.trailing).offset(10)
            maker.trailing.lessThanOrEqualTo(playItem.snp.leading).offset(-10)
        }
        nextItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(icon)
            maker.trailing.equalToSuperview().offset(-25)
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
        nextItem.isEnabled = false
        nextItem.titleLabel?.font = UIFont(icon: 28)
        nextItem.setTitle(String(.next), for: .normal)
        nextItem.setTitleColor(.black, for: .normal)
        nextItem.addTarget(self, action: #selector(onClickNext(_:)), for: .touchUpInside)
        contentView.addSubview(nextItem)
    }
    
    private func setupPlayItem() {
        playItem.titleLabel?.font = UIFont(icon: 28)
        playItem.setTitle(String(AudioPlayer.Sington.isPlaying ? .pause : .play), for: .normal)
        playItem.setTitleColor(.black, for: .normal)
        playItem.addTarget(self, action: #selector(onClickPlay(_:)), for: .touchUpInside)
        contentView.addSubview(playItem)
    }
}
