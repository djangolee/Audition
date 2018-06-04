//
//  UIFont+Icon.swift
//  Audition
//
//  Created by Panghu Lee on 27/11/2017.
//  Copyright © 2017 Panghu Lee. All rights reserved.
//

import UIKit

extension UIFont {
    
    convenience public init?(icon fontSize: CGFloat) {
        self.init(name: "AuditionIconFont", size: fontSize)
    }
}
