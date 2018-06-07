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
                return UIImage(named: "folder")
            } else if ["mp3", "wav"].contains(pathExtension) {
                return UIImage(named: "audio")
            }
            return UIImage(named: "file")
        }
        
        var isSound: Bool {
            return ["mp3", "wav"].contains(pathExtension)
        }
        
        init?(_ path: String) throws {

            let url = URL(fileURLWithPath: path)
            var lastPathComponent = url.lastPathComponent
            if let range = lastPathComponent.range(of: "." + url.pathExtension) {
                lastPathComponent.removeSubrange(range)
            }
            self.name = lastPathComponent
            self.pathExtension = url.pathExtension
            self.path = path
            
            if !url.lastPathComponent.hasPrefix("."),
                let attributes = try? FileManager.default.attributesOfItem(atPath: path),
                let hidden = attributes[FileAttributeKey.extensionHidden] as? Bool,
                hidden == false {
                
                date = attributes[FileAttributeKey.modificationDate] as? Date
                size = attributes[FileAttributeKey.size] as? Int
                type = (attributes[FileAttributeKey.type] as? FileAttributeType) ?? .typeUnknown
            } else {
                return nil
            }
        }
        
        public func contentsOfDirectory() -> [FileInfo]? {
            guard type == .typeDirectory
                else { return nil }
            return FileManager.default.scanDirectory(path)
        }
    }
    
    #if arch(i386) || arch(x86_64)
    public private(set) static var ScanDirectory = Home + "/Documents/Audio"
    public private(set) static var AudioDirectory = Home + "/Library/Audio"
    public private(set) static var Home = "/Users/panghu/Source/Sandbox"
    #else
    public private(set) static var ScanDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    public private(set) static var AudioDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "/Audio"
    public private(set) static var Home = NSHomeDirectory()
    #endif
    
    public func scanDirectory(_ path: String) -> [FileInfo]? {
        
        return try? contentsOfDirectory(atPath: path)
            .map { dir -> FileInfo? in
                return try FileInfo(path + "/" + dir)
            }
            .compactMap { $0 }
            .sorted(by: { info1, info2 -> Bool in
                if info1.type == .typeDirectory, info2.type != .typeDirectory {
                    return true;
                }
                if info2.type == .typeDirectory, info1.type != .typeDirectory {
                    return false;
                }
                if info2.type == .typeDirectory, info1.type == .typeDirectory {
                    return info1.name < info2.name
                }
                if info2.type != .typeDirectory, info1.type != .typeDirectory {
                    return info1.name < info2.name
                }
                return false;
            })
    }
    
    public func scan() -> [FileInfo]? {
        return scanDirectory(FileManager.ScanDirectory)
    }
    
    
    
}
