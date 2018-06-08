//
//  PlayControlLayer.swift
//  Listening
//
//  Created by Panghu Lee on 30/11/2017.
//  Copyright © 2017 Panghu Lee. All rights reserved.
//

import UIKit

public class PlayControlLayer: CALayer {
    
    public enum State {
        case prepare
        case play
        case pause
    }
    
    private let backgroudLayer = CALayer()
    private let innerCircle = CALayer()
    private let controlIcon = CAShapeLayer()
    private let outerCircle = CALayer()
    private let prepareState = CAReplicatorLayer()
    private let progressLayer = CAShapeLayer()
    
    static let blackColor = UIColor(white: 0.4, alpha: 0.7).cgColor
    static let whiteColor = UIColor(white: 0.95, alpha: 1).cgColor
    static let outerSize: CGFloat = 36
    static let innerSize: CGFloat = 25
    
    public var state: State = .pause {
        didSet {
            updateState(old: oldValue)
        }
    }
    
    public var progress: CGFloat {
        get { return progressLayer.strokeStart }
        set { progressLayer.strokeStart = newValue }
    }
}


//MARK: Load View

extension PlayControlLayer {
    
    override public func layoutSublayers() {
        super.layoutSublayers()
        updateLayoutSublayers()
    }
    public override func jo_setupSublayers() {
        super.jo_setupSublayers()
        setupSubLayer()
        setupReplicatorLayer()
    }
    
    public override func jo_makeSublayersLayout() {
        super.jo_makeSublayersLayout()
        
        let outer = PlayControlLayer.outerSize
        let inner = PlayControlLayer.innerSize
        
        outerCircle.frame.size = CGSize(width: outer, height: outer)
        outerCircle.cornerRadius = outerCircle.frame.width / 2
        
        innerCircle.frame.size = CGSize(width: inner, height: inner)
        innerCircle.cornerRadius = innerCircle.frame.width / 2
        
        prepareState.frame.size = CGSize(width: outer, height: outer)
        prepareState.cornerRadius = prepareState.frame.width / 2
        
        progressLayer.frame.size = CGSize(width: outer, height: outer)
        progressLayer.cornerRadius = progressLayer.frame.width / 2
    
        let lineWidth: CGFloat = outer / 2
        let rect = CGRect(x: lineWidth / 2, y: lineWidth / 2, width: prepareState.bounds.width - lineWidth, height: prepareState.bounds.height - lineWidth)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: prepareState.frame.width / 2)
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = lineWidth
    }
    
    private func updateLayoutSublayers() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        outerCircle.position = center
        innerCircle.position = center
        updateStateLayoutIcon()
        updateStateLayoutOuterAndBackgroud()
    }
    
    private func updateState(old: PlayControlLayer.State) {
        updateStateLayoutIcon()
        updateStateLayoutOuterAndBackgroud()
        prepareState.isHidden = state != .prepare
        progressLayer.isHidden = state != .play
    }
    
    private func updateStateLayoutOuterAndBackgroud() {
        let outer = PlayControlLayer.outerSize
        let inner = PlayControlLayer.innerSize
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        outerCircle.transform = state == .pause ? CATransform3DMakeScale(0, 0, 0) : CATransform3DMakeScale(1, 1, 1)
        backgroudLayer.frame.size = CGSize(width: state == .pause ? inner : outer, height: state == .pause ? inner : outer)
        backgroudLayer.position = center
        backgroudLayer.cornerRadius = backgroudLayer.frame.width / 2
    }
    
    private func updateStateLayoutIcon() {
        let path = UIBezierPath()
        if state == .pause {
            let width = min(innerCircle.bounds.width, innerCircle.bounds.height)
            let side = width / 2.5
            let bisector = side
            let rect = CGRect(x: (width - side) / 1.75, y: (width - bisector) / 2, width: bisector, height: side)
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: rect.origin)
            
        } else {
            let width = min(innerCircle.bounds.width, innerCircle.bounds.height)
            let side = width / 2
            let thickness = width / 9
            let rect = CGRect(x: (width - thickness * 3) / 2, y: (width - side) / 2, width: thickness * 3, height: side)
            
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + thickness, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + thickness, y: rect.minY))
            path.addLine(to: rect.origin)
            
            let moveX = thickness * 2
            path.move(to: CGPoint(x: rect.minX + moveX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + moveX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + moveX + thickness, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + moveX + thickness, y: rect.minY))
            path.addLine(to: rect.origin)
        }
        controlIcon.path = path.cgPath
    }
    
    private func setupSubLayer() {
        let black = PlayControlLayer.blackColor
        let white = PlayControlLayer.whiteColor
        
        backgroudLayer.backgroundColor = white
        addSublayer(backgroudLayer)
        
        outerCircle.borderWidth = 1
        outerCircle.borderColor = white
        outerCircle.shadowRadius = 3
        outerCircle.shadowOpacity = 0.8
        outerCircle.shadowOffset = CGSize.zero
        addSublayer(outerCircle)
        
        innerCircle.borderWidth = 1.5
        innerCircle.borderColor = white
        innerCircle.shadowRadius = 3
        innerCircle.shadowOpacity = 0.8
        innerCircle.shadowOffset = CGSize.zero
        innerCircle.backgroundColor = black
        addSublayer(innerCircle)
        
        controlIcon.fillColor = UIColor.white.cgColor
        innerCircle.addSublayer(controlIcon)
        
        progressLayer.strokeColor = black
        progressLayer.strokeEnd = 1
        outerCircle.addSublayer(progressLayer)
    }
    
    private func setupReplicatorLayer() {
        let count: Int = 15
        let size = PlayControlLayer.outerSize
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addArc(withCenter: CGPoint(x: 0, y: size / 2), radius: size / 2, startAngle: 1.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi + CGFloat.pi * 2 / CGFloat(count), clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: size / 2))
        path.addLine(to: CGPoint.zero)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        let subLayer = CALayer()
        subLayer.frame = CGRect(x: size / 2, y: 0, width: size / 2, height: size / 2)
        subLayer.mask = shapeLayer
        
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        anim.toValue = PlayControlLayer.whiteColor
        anim.fromValue = PlayControlLayer.blackColor
        anim.isRemovedOnCompletion = false
        subLayer.add(anim, forKey: nil)
        
        prepareState.addSublayer(subLayer);
        prepareState.instanceCount = count
        prepareState.instanceDelay = 1 / CFTimeInterval(count)
        prepareState.instanceTransform = CATransform3DMakeRotation(CGFloat.pi * 2 / CGFloat(count), 0, 0, 1.0)
        prepareState.isHidden = state != .prepare
        outerCircle.addSublayer(prepareState)
    }
}
