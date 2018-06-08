//
//  PreviewPlayControl.swift
//  Listening
//
//  Created by Panghu Lee on 30/11/2017.
//  Copyright © 2017 Panghu Lee. All rights reserved.
//

import UIKit

open class PreviewPlayControl: UIButton {

    private let playIcon = PreviewPlayControlLayer()
    
    public var playState: PreviewPlayControlLayer.State {
        get { return playIcon.state }
        set { playIcon.state = newValue }
    }
    
    public var progress: CGFloat {
        get {  return playIcon.progress }
        set { playIcon.progress = newValue }
    }
    
    //MARK: Autolayout

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxSize = PreviewPlayControlLayer.outerSize
        return CGSize(width: maxSize, height: maxSize)
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }

}


//MARK: Load View

extension PreviewPlayControl {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        playIcon.frame.size = sizeThatFits(CGSize.zero)
        playIcon.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    override open func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupPlayIcon()
    }
    
    private func setupPlayIcon() {
        
        layer.addSublayer(playIcon)
    }
}
