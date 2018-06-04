//
//  UIImage+Icon.swift
//  Audition
//
//  Created by Panghu Lee on 27/11/2017.
//  Copyright © 2017 Panghu Lee. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience public init?(icon: String.UnicodeIcon, pointSize: CGFloat, textColor: UIColor = .black, backgroundColor: UIColor = .clear) {
        
        let text = String(icon)
        let attributes = UIImage.attributesCollection(pointSize: pointSize, textColor: textColor, backgroundColor: backgroundColor)
        let rect = UIImage.boundingRect(text, attributes: attributes)
        
        // Context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        (text as NSString).draw(in: rect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage  else { return nil }
        self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
    }
    
    private class func boundingRect(_ text: String, attributes: [NSAttributedString.Key : Any]? = nil) -> CGRect {
        return (text as NSString).boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    
    private class func attributesCollection(pointSize: CGFloat, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) -> [NSAttributedString.Key: Any]? {
        guard let font = UIFont(icon:pointSize) else { return nil }
        
        return [NSAttributedString.Key.font:                 font,
                NSAttributedString.Key.foregroundColor:      textColor,
                NSAttributedString.Key.backgroundColor:      backgroundColor]
    }
    
}
