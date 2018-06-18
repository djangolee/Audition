//
//  PlaylistViewController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/10.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let playlist = AudioPlayerList.default
    public let playboardView = PlayboardView()
    
    private let panRecognizer = UIPanGestureRecognizer()
    
    init(_ tabbarSize: CGSize) {
        super.init(nibName: nil, bundle: nil)
        playboardView.audioTabbar.bounds.size = tabbarSize
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
    
    @objc private func onPanRecognizer(_ sender: UIPanGestureRecognizer) {
        
        guard let transitioning = self.transitioningDelegate as? LibraryTransitioning else {
            return
        }
        
        guard let tableView = sender.view as? UITableView, tableView == self.tableView else {
            return
        }
        
        switch sender.state {
        case .possible, .began:
            break
        case .changed:
            if tableView.adjustedContentInset.top + tableView.contentOffset.y <= 0 {
                if !transitioning.isInteraction {
                    transitioning.isInteraction = true
                    playboardView.foldItem.direction = .flat
                    dismiss(animated: true, completion: nil)
                }
                if transitioning.isInteraction {
                    let offsetY = sender.translation(in: sender.view).y
                    let progress = offsetY / tableView.frame.height / 2.2
                    transitioning.update(progress)
                    tableView.bounces = false
                }
            } else {
                transitioning.update(0)
                tableView.bounces = true
                playboardView.foldItem.direction = .down
                transitioning.isInteraction = false
            }
            break
        case .ended, .cancelled:
            tableView.bounces = true
            playboardView.foldItem.direction = .down
            transitioning.isInteraction = false
            
            transitioning.percentComplete > 0.2 ? transitioning.finish() : transitioning.cancel()
            break
        case .failed:
            tableView.bounces = true
            playboardView.foldItem.direction = .down
            transitioning.isInteraction = false
            
            transitioning.cancel()
            break
        }
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.playlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.jo.dequeueReusableCell(UITableViewCell.self)!
        cell.textLabel?.text = playlist.playlist?[indexPath.item].name
        cell.textLabel?.textColor = UIColor.init(red: 252 / 256.0, green: 47 / 256.0, blue: 85 / 256.0, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
            else { return }

        cell.setSelected(false, animated: true)
    }
}

extension PlaylistViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard gestureRecognizer === panRecognizer
            else { return true }
        
        let translation = panRecognizer.translation(in: view)
        guard abs(translation.y) > abs(translation.x)
            else { return false }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        panRecognizer.addTarget(self, action: #selector(onPanRecognizer(_:)))
        panRecognizer.delegate = self
        tableView.addGestureRecognizer(panRecognizer)

        let volumeView = MPVolumeView()
        volumeView.center = CGPoint(x: 199999, y: 1999999)
        view.addSubview(volumeView)
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupTableView()
        setupPlayboardView()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
    
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.jo.register(cell: UITableViewCell.self)
        view.addSubview(tableView)
    }
    
    private func setupPlayboardView() {
        playboardView.frame.size = playboardView.sizeThatFits(CGSize.zero)
        playboardView.foldItem.addTarget(self, action: #selector(onClickFlodItem(_:)), for: .touchUpInside)
        tableView.tableHeaderView = playboardView
    }
    
}
