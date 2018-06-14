//
//  LibraryTransitioning.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/13.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

class LibraryTransitioning: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    private var backgroundView = UIView()
    private var snapshotView = UIView()
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
        return 10
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(true)
                return
        }
        
        let containerView = transitionContext.containerView
        
        if isDismiss {
            transitionContext.completeTransition(true)
            backgroundView.removeFromSuperview()
            snapshotView.removeFromSuperview()
            fromView.removeFromSuperview()
        } else {
            
            snapshotView = fromView.snapshotView(afterScreenUpdates: true) ?? snapshotView
            snapshotView.clipsToBounds = true
            snapshotView.transform = CGAffineTransform()
            snapshotView.frame = containerView.bounds
            snapshotView.center.y += 20
            containerView.addSubview(snapshotView)
            
            backgroundView.alpha = 0.5
            backgroundView.backgroundColor = .black
            backgroundView.frame = containerView.bounds
            containerView.addSubview(backgroundView)
            
            toView.frame.size = containerView.bounds.size
            toView.frame.origin.y = containerView.bounds.height
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame.origin.y = 0
//                self.backgroundView.alpha = 0.3
//                self.snapshotView.frame.origin.y = 20
                self.snapshotView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                transitionContext.completeTransition(true)
                containerView.insertSubview(fromView, belowSubview: self.backgroundView)
            }
        }
    }
    
}
