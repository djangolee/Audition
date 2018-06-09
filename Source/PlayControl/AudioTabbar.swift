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
