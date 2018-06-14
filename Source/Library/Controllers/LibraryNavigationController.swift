//
//  LibraryNavigationController.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/10.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class LibraryNavigationController: UINavigationController {
    
    internal let audioTabbar = AudioTabbar()
    private let panGesture = UIPanGestureRecognizer()
    
    private var topInsert: CGFloat = 55
    private var topDistance: CGFloat = 0
    
    private let transitioning = LibraryTransitioning()
    
    init() {
        let roor = LibraryViewController.init(FileManager.default.scan() ?? [], title: "Documents")
        super.init(rootViewController: roor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topDistance = view.frame.height - topInsert - audioTabbar.frame.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func hideenProgress(_ progress: CGFloat) {
        
    }
    
    func showProgress(_ progress: CGFloat) {
//        let offset = max(min(progress, 1), 0)
//        print(offset)
    }
    
    @objc private func onPanTabbar(_ sender: UIPanGestureRecognizer) {
        print(#function)
        let  translation = panGesture.translation(in: view)
        switch sender.state {
        case .possible, .began, .changed:
            if translation.y < 0 {
                showProgress(abs(translation.y) / topDistance)
            }
            break
        case .ended, .cancelled, .failed:
            showProgress(0)
            break
        }
    }
    
    @objc private func onClickTabbar(_ sender: UIControl) {
        let playVC = PlaylistViewController()
        playVC.transitioningDelegate = transitioning
        present(playVC, animated: true, completion: nil)
    }
}

extension LibraryNavigationController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === panGesture
            else { return true }

        let translation = panGesture.translation(in: view)
        guard translation.y < -3
            else { return false }
    
        return true
    }
}

extension LibraryNavigationController {
    
    override func jo_viewDidInstallSubviews() {
        super.jo_viewDidInstallSubviews()
        navigationBar.prefersLargeTitles = true
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupAudioTabbar()
        
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        let height = view.safeAreaInsets.bottom + AudioTabbar.TabBarHeight
        additionalSafeAreaInsets.bottom += AudioTabbar.TabBarHeight
        
        audioTabbar.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(height)
        }
    }
    
    private func setupAudioTabbar() {
        panGesture.addTarget(self, action: #selector(onPanTabbar(_:)))
        panGesture.delegate = self
        audioTabbar.contentView.addGestureRecognizer(panGesture)
        audioTabbar.contentItem.addTarget(self, action: #selector(onClickTabbar(_:)), for: .touchUpInside)
        audioTabbar.contentView.jo.setSeparator(.top)
        view.addSubview(audioTabbar)
    }
}
