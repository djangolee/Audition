//
//  String+Icon.swift
//  Audition
//
//  Created by Panghu Lee on 27/11/2017.
//  Copyright © 2017 Panghu Lee. All rights reserved.
//

import Foundation

extension String {
    
    public enum UnicodeIcon: UInt32 {

        case other = 0xe665
    }
    
    public init(_ icon: UnicodeIcon) {
        self.init(Character(UnicodeScalar(icon.rawValue)!))
    }
}
