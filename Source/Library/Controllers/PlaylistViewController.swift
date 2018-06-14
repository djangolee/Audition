//
//  PlaylistViewController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/10.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    enum Style {
        case fold
        case unfold
    }
    
    public var style: Style = .unfold {
        didSet { didSetStyle() }
    }
    
    public let audioTabbar = AudioTabbar()
    
    private let tableView = UITableView()
    private let playboardView = UIView()
    private let foldItem = ArrowFoldItem()
    private let coverImageView = UIImageView(image: UIImage(named: "AudioIcon"))
    private let progressView = UIProgressView()
    
    init(_ tabbarSize: CGSize) {
        super.init(nibName: nil, bundle: nil)
        audioTabbar.bounds.size = tabbarSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func onClickFlodItem(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
}

extension PlaylistViewController {
    
    public func didSetStyle() {
        playboardView.addSubview(audioTabbar)
        playboardView.addSubview(coverImageView)
        playboardView.addSubview(progressView)
        
        switch style {
        case .fold:
            audioTabbar.alpha = 1
            foldItem.alpha = 0
            progressView.alpha = 0.1
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
        setupTableView()
        setupPlayboardView()
        setupAudioTabbar()
        setupFoldItem()
        setupCover()
        setupProgressView()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
    
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        foldItem.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
    }
    
    private func setupPlayboardView() {
        playboardView.bounds = tableView.bounds
        playboardView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        tableView.tableHeaderView = playboardView
    }
    
    private func setupAudioTabbar() {
        audioTabbar.contentView.jo.setSeparator(.top)
        audioTabbar.frame.origin = .zero
        audioTabbar.icon.isHidden = true
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
    
    private func setupProgressView() {
        playboardView.addSubview(progressView)
    }
}
