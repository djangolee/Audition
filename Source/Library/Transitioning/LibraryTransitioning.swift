//
//  LibraryTransitioning.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/13.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class LibraryTransitioning: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    private var blackboardView = UIView()
    private var snapshotView = UIView()
    private var maskingView = UIView()
    
    private var isDismiss = false
    
    //MARK: UIViewControllerAnimatedTransitioning
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = false
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = true
        return self
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isDismiss {
            dismissAnimateTransition(using: transitionContext)
        } else {
            presentAnimateTransition(using: transitionContext)
        }
    }
    
    func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let playlistViewController = transitionContext.viewController(forKey: .to) as? PlaylistViewController else {
            return
        }
        
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(true)
                return
        }
        
        let containerView = transitionContext.containerView
        
        blackboardView.frame = containerView.bounds
        blackboardView.backgroundColor = .black
        containerView.addSubview(blackboardView)
        
        snapshotView = fromView.snapshotView(afterScreenUpdates: true) ?? snapshotView
        snapshotView.transform = CGAffineTransform(scaleX: 1, y: 1)
        snapshotView.frame = containerView.bounds
        snapshotView.clipsToBounds = true
        snapshotView.layer.cornerRadius = 8
        containerView.addSubview(snapshotView)
        
        maskingView.alpha = 0
        maskingView.backgroundColor = .black
        maskingView.frame = containerView.bounds
        containerView.addSubview(maskingView)
        
        toView.clipsToBounds = true
        toView.layer.cornerRadius = 8
        toView.frame.size = CGSize(width: containerView.frame.width, height: containerView.frame.height - 55)
        toView.frame.origin.y = containerView.bounds.height - playlistViewController.audioTabbar.frame.height
        containerView.addSubview(toView)
        
        playlistViewController.style = .fold
        playlistViewController.audioTabbar.isHidden = false
        playlistViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            playlistViewController.style = .unfold
            playlistViewController.view.layoutIfNeeded()
            
            toView.frame.origin.y = 55
            self.maskingView.alpha = 0.3
            self.snapshotView.frame.origin.y = 15
            self.snapshotView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }) { _ in
            playlistViewController.audioTabbar.isHidden = true
            transitionContext.completeTransition(true)
        }
        
    }
    
    func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let playlistViewController = transitionContext.viewController(forKey: .from) as? PlaylistViewController else {
            
            transitionContext.completeTransition(true)
            self.blackboardView.removeFromSuperview()
            self.snapshotView.removeFromSuperview()
            self.maskingView.removeFromSuperview()
            return
        }
        
        guard let fromView = transitionContext.view(forKey: .from) else {
            
            transitionContext.completeTransition(true)
            self.blackboardView.removeFromSuperview()
            self.snapshotView.removeFromSuperview()
            self.maskingView.removeFromSuperview()
                return
        }
        
        let containerView = transitionContext.containerView
        
        playlistViewController.style = .unfold
        playlistViewController.audioTabbar.isHidden = false
        playlistViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            playlistViewController.style = .fold
            playlistViewController.view.layoutIfNeeded()
            
            fromView.frame.origin.y = containerView.bounds.height - playlistViewController.audioTabbar.frame.height
            self.maskingView.alpha = 0
            self.snapshotView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.snapshotView.frame.origin.y = 1
        }) { _ in
            transitionContext.completeTransition(true)
            self.blackboardView.removeFromSuperview()
            self.snapshotView.removeFromSuperview()
            self.maskingView.removeFromSuperview()
        }
    }
    
}
