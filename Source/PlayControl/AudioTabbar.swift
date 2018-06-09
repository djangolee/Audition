//
//  AudioTabbar.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/8.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class AudioTabbar: UIToolbar {
    
    private let icon = UIImageView(image: UIImage(named: "AudioIcon"))
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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

    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        nameLabel.text = AudioPlayer.Sington.source?.name
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
            maker.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupIcon() {
        icon.clipsToBounds = true;
        icon.layer.cornerRadius = 3
        addSubview(icon)
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Not Playing"
        nameLabel.font = .systemFont(ofSize: 15)
        addSubview(nameLabel)
    }
}
