//
//  FileManager.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/5.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    
    public struct FileInfo {
        let path: String
        let name: String
        let pathExtension: String
        
        let date: Date?
        let size: Int?
        let type: FileAttributeType
        
        var fileIcon: UIImage? {
            if type == FileAttributeType.typeUnknown {
                return UIImage(named: "file")
            } else if type == FileAttributeType.typeDirectory {
                return UIImage(named: "folder-star")
            } else if ["mp3", "wav"].contains(pathExtension) {
                return UIImage(named: "file-audio")
            }
            return UIImage(named: "file")
        }
        
        init?(_ path: String) throws {

            let url = URL(fileURLWithPath: path)
            self.name = url.lastPathComponent
            self.pathExtension = url.pathExtension
            self.path = path
            
            if let attributes = try? FileManager.default.attributesOfItem(atPath: path),
                let hidden = attributes[FileAttributeKey.extensionHidden] as? Bool,
                hidden == false {
                
                date = attributes[FileAttributeKey.modificationDate] as? Date
                size = attributes[FileAttributeKey.size] as? Int
                type = (attributes[FileAttributeKey.type] as? FileAttributeType) ?? .typeUnknown
            } else {
                return nil
            }
        }
    }
    
    #if arch(i386) || arch(x86_64)
    public private(set) static var ScanDirectory = Home + "/Documents/Audio"
    public private(set) static var AudioDirectory = Home + "/Library/Audio"
    public private(set) static var Home = "/Users/panghu/Source/Sandbox"
    #else
    public private(set) static var ScanDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Audio"
    public private(set) static var AudioDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "/Audio"
    public private(set) static var Home = NSHomeDirectory()
    #endif
    
    public func scanAudio() -> [FileInfo]? {
        return try? FileManager.default.contentsOfDirectory(atPath: FileManager.ScanDirectory)
            .map { path -> FileInfo? in
                return try FileInfo(FileManager.ScanDirectory + "/" + path)
            }
            .compactMap { $0 }
    }
    
}
