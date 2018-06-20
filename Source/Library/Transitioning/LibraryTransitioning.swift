//
//  LibraryTransitioning.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/13.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class LibraryTransitioning: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    public var isDismiss = false
    public var isInteraction: Bool = false
    
    private var blackboardView = UIView()
    private var snapshotView = UIView()
    private var maskingView = UIView()
    
    public func dismissUpdate(_ percentComplete: CGFloat) {
        let scale = 0.05 * min(percentComplete, 1)
        snapshotView.transform = CGAffineTransform(scaleX: 0.94 + scale, y: 0.94 + scale)
        snapshotView.frame.origin.y = 40 - 15 * min(percentComplete, 1)
    }
    
    public func dismissFinish() {
        
    }
    
    public func dismissCancel() {
        UIView.animate(withDuration: 0.25) {
            self.snapshotView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            self.snapshotView.frame.origin.y = 40
        }
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = false
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismiss = true
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteraction ? self : nil;
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteraction ? self : nil;
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isDismiss {
            dismissAnimateTransition(using: transitionContext)
        } else {
            isInteraction ? presentInteractionAnimateTransition(using: transitionContext) : presentAnimateTransition(using: transitionContext)
        }
    }
    
    func presentInteractionAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.presentAnimateTransition(using: transitionContext)
    }
        
    func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let playlistViewController = transitionContext.viewController(forKey: .to) as? PlaylistViewController else {
            return
        }
        
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
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
        
        toView.frame = containerView.bounds
        toView.frame.origin.y = containerView.bounds.height - playlistViewController.playboardView.audioTabbar.frame.height - 55
        containerView.addSubview(toView)
        
        playlistViewController.playboardView.style = .fold
        playlistViewController.playboardView.audioTabbar.isHidden = false
        playlistViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            playlistViewController.playboardView.style = .unfold
            playlistViewController.view.layoutIfNeeded()
            
            toView.frame.origin.y = 0
            self.maskingView.alpha = 0.3
            self.snapshotView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            self.snapshotView.frame.origin.y = 40
        }) { _ in
            playlistViewController.playboardView.audioTabbar.isHidden = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let playlistViewController = transitionContext.viewController(forKey: .from) as? PlaylistViewController else {
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.blackboardView.removeFromSuperview()
            self.snapshotView.removeFromSuperview()
            self.maskingView.removeFromSuperview()
            return
        }
        
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.blackboardView.removeFromSuperview()
            self.snapshotView.removeFromSuperview()
            self.maskingView.removeFromSuperview()
                return
        }
        
        let containerView = transitionContext.containerView
        
        playlistViewController.playboardView.style = .unfold
        playlistViewController.playboardView.audioTabbar.isHidden = false
        playlistViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            playlistViewController.playboardView.style = .fold
            playlistViewController.view.layoutIfNeeded()
            
            let tableView = playlistViewController.tableView
            let offsetY = tableView.frame.origin.y
            
            fromView.frame.origin.y = containerView.bounds.height - offsetY - playlistViewController.playboardView.audioTabbar.frame.height
            self.maskingView.alpha = 0
            self.snapshotView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.snapshotView.frame.origin.y = 0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                self.blackboardView.removeFromSuperview()
                self.snapshotView.removeFromSuperview()
                self.maskingView.removeFromSuperview()
            } else {
                playlistViewController.playboardView.style = .unfold
            }
        }
    }
}
