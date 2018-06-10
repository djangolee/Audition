//
//  PlaylistViewController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/10.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let audioTabbar = AudioTabbar()
    private let backgroundView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

}

extension PlaylistViewController {
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        view.backgroundColor = .white
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupBackgroundView()
        setupAudioTabbar()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        audioTabbar.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(AudioTabbar.TabBarHeight)
        }
    }
    
    private func setupBackgroundView() {
        
        view.addSubview(backgroundView)
    }
    
    private func setupAudioTabbar() {
        audioTabbar.contentView.jo.setSeparator(.top)
        view.addSubview(audioTabbar)
    }
}
