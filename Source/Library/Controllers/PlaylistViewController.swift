//
//  PlaylistViewController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/10.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let foldItem = ArrowFoldItem()
    private let audioTabbar = AudioTabbar()
    private let backgroundView = UIView()
    private let contentView = UIView()
    private let playboardView = UIView()
    private let tableView = UITableView()
    private let coverImageView = UIImageView(image: UIImage(named: "AudioIcon"))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func onClickFlodItem(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
}

extension PlaylistViewController {
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
//        view.backgroundColor = .white
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupBackgroundView()
        setupContentView()
        setupTableView()
        setupPlayboardView()
        setupAudioTabbar()
        setupFoldItem()
        setupCover()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0))
        }

        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        audioTabbar.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(AudioTabbar.TabBarHeight)
        }
        
        foldItem.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { maker in
            maker.top.leading.equalToSuperview().inset(62)
            maker.width.equalTo(UIScreen.main.bounds.width - 62 * 2)
            maker.height.equalTo(coverImageView.snp.width)
        }
    }
    
    private func setupBackgroundView() {
//        backgroundView.backgroundColor = .black
        view.addSubview(backgroundView)
    }
    
    private func setupContentView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        backgroundView.addSubview(contentView)
    }
    
    private func setupTableView() {
        contentView.addSubview(tableView)
    }
    
    private func setupPlayboardView() {
        playboardView.bounds = tableView.bounds
        playboardView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        tableView.tableHeaderView = playboardView
    }
    
    private func setupAudioTabbar() {
        audioTabbar.contentView.jo.setSeparator(.top)
        playboardView.addSubview(audioTabbar)
    }

    private func setupFoldItem() {
        foldItem.addTarget(self, action: #selector(onClickFlodItem(_:)), for: .touchUpInside)
        playboardView.addSubview(foldItem)
    }
    
    private func setupCover() {
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 5
        playboardView.addSubview(coverImageView)
    }
}
