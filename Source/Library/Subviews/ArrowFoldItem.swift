//
//  ArrowFoldItem.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/12.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit

public class ArrowFoldItem: UIButton {
    
    private let arrowLayer = CAShapeLayer()
    
    public enum Direction {
        case down, flat
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 45, height: 30)
    }
    
    public override var intrinsicContentSize: CGSize {
        return sizeThatFits(bounds.size)
    }
    
    public var direction = ArrowFoldItem.Direction.down {
        didSet {
            if oldValue != direction {
                CATransaction.begin()
                CATransaction.setAnimationDuration(1)
                didSetDirection()
                CATransaction.commit()
            }
        }
    }
}

//MARK: Load View

extension ArrowFoldItem {
    
    private static let arrowWidth: CGFloat = 30
    private static let arrowHeight: CGFloat = 30
    private static let arrowLineWidth: CGFloat = 5
    
    private func didSetDirection() {
        let rect = CGRect(x: (bounds.width - ArrowFoldItem.arrowWidth) / 2, y: (bounds.height - ArrowFoldItem.arrowHeight) / 2,
                          width: ArrowFoldItem.arrowWidth, height: ArrowFoldItem.arrowHeight)
        let path = UIBezierPath()
        if direction == .down {
            path.move(to: CGPoint(x: rect.minX, y: rect.midY - ArrowFoldItem.arrowLineWidth / 2))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + ArrowFoldItem.arrowLineWidth / 2))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - ArrowFoldItem.arrowLineWidth / 2))
        } else if direction == .flat {
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
        arrowLayer.path = path.cgPath
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        arrowLayer.frame = bounds
        didSetDirection()
    }
    
    public override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupArrowLayer()
    }
    
    private func setupArrowLayer() {
        arrowLayer.strokeColor = UIColor.lightGray.cgColor
        arrowLayer.lineWidth = ArrowFoldItem.arrowLineWidth
        arrowLayer.lineJoin = .round
        arrowLayer.lineCap = .round
        arrowLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(arrowLayer)
    }
}
