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
    
    public let tableView = UITableView()
    public let playboardView = PlayboardView()
    private let maskLayer = CAShapeLayer()
    
    private let playlist = AudioPlayerList.default
    
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
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    static let threshold: CGFloat = 150
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let transitioning = transitioningDelegate as? LibraryTransitioning
            else {
                return
        }
        
        let offsetY = min(tableView.adjustedContentInset.top + tableView.contentOffset.y, 0)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame.origin.y = scrollView.frame.origin.y + abs(offsetY)
        CATransaction.commit()
        playboardView.foldItem.direction = maskLayer.frame.origin.y > scrollView.frame.origin.y && scrollView.isTracking ? .flat : .down
        transitioning.dismissUpdate(max(maskLayer.frame.origin.y - 55, 0) / PlaylistViewController.threshold)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetY = abs(scrollView.contentOffset.y) + scrollView.frame.origin.y
        if scrollView.contentOffset.y < 0, offsetY > PlaylistViewController.threshold {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            tableView.snp.remakeConstraints { maker in
                maker.top.equalToSuperview().offset(offsetY)
                maker.leading.bottom.trailing.equalToSuperview()
            }
            view.layoutIfNeeded()
            scrollView.contentOffset.y = 0
            maskLayer.frame.origin.y = offsetY
            CATransaction.commit()
            dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.playlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.jo.dequeueReusableCell(PlaylistTableViewCell.self) as! PlaylistTableViewCell
        if let file = playlist.playlist?[indexPath.item] {
            cell.render(file)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
            else { return }

        cell.setSelected(false, animated: true)
        if let file = playlist.playlist?[indexPath.item], file.isSound {
            playlist.play(file.siblingAudio(), file: file)
            playlist.audioPlayer.resume()
        }
    }
}

extension PlaylistViewController : UIGestureRecognizerDelegate {
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()

        let volumeView = MPVolumeView()
        volumeView.center = CGPoint(x: 199999, y: 1999999)
        view.addSubview(volumeView)
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupTableView()
        setupPlayboardView()
        setupMaskLayer()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
    
        tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(55)
            maker.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.jo.register(cell: PlaylistTableViewCell.self)
        view.addSubview(tableView)
    }
    
    private func setupPlayboardView() {
        playboardView.foldItem.addTarget(self, action: #selector(onClickFlodItem(_:)), for: .touchUpInside)
        playboardView.sizeToFit()
        tableView.tableHeaderView = playboardView
    }
    
    private func setupMaskLayer() {
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8)
        path.close()
        maskLayer.path = path.cgPath
        maskLayer.frame = view.bounds
        maskLayer.frame.origin.y = 55
        view.layer.mask = maskLayer
    }
    
}
