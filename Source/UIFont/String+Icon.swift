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

        case previous = 0xe67d
        case play = 0xe67f
        case pause = 0xe681
        case next = 0xe680
        case volumemin = 0xe682
        case volumemax = 0xe683
    }
    
    public init(_ icon: UnicodeIcon) {
        self.init(Character(UnicodeScalar(icon.rawValue)!))
    }
}
