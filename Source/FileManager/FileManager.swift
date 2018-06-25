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
        let subcount: Int?
        let type: FileAttributeType
        
        var des: String {
            var string = dateString
            if type == .typeDirectory {
                string += " - \(subcount ?? 0) item"
            } else {
                string += " - \(sizeString)"
            }
            return string
        }
        
        var isSound: Bool {
            return ["mp3", "wav", "flac"].contains(pathExtension)
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
                subcount = FileManager.default.subpaths(atPath: path)?.count
            } else {
                return nil
            }
        }
        
        public func contentsOfDirectory() -> [FileInfo]? {
            guard type == .typeDirectory
                else { return nil }
            return FileManager.default.scanDirectory(path)
        }
        
        func siblingAudio() -> [FileInfo] {
            let siblinglist = FileManager.default.scanSibling(self) ?? [self]
            return siblinglist.filter { $0.isSound }
        }
        
        var dateString: String {
            if let date = date {
                let formater = DateFormatter()
                formater.dateFormat = "dd/MM/yyyy"
                return formater.string(from: date)
            } else {
                return "-/-/-"
            }
        }
        
        var sizeString: String {
            if let size = size {
                if size < 1024 {
                    return "\(size) bytes"
                }
                let nkb = Float(size) / 1024.0
                if nkb < 1024 {
                    return "\(Float(Int(nkb * 100)) / 100.0) KB"
                }
                let nmb = nkb / 1024.0
                if nmb < 1024 {
                    return "\(Float(Int(nmb * 100)) / 100.0) MB"
                }
                let ngb = nmb / 1024.0
                if ngb < 1024 {
                    return "\(Float(Int(ngb * 100)) / 100.0) GB"
                }
            }
            return "- bytes"
        }
        
        var fileIcon: UIImage? {
            if type == FileAttributeType.typeUnknown {
                return UIImage(named: "file")
            } else if type == FileAttributeType.typeDirectory {
                return UIImage(named: "folder")
            } else if isSound {
                return UIImage(named: "audio")
            }
            return UIImage(named: "file")
        }
    }
    
    #if arch(i386) || arch(x86_64)
    public private(set) static var Home = "/Users/panghu/Source/Sandbox"
    #else
    public private(set) static var Home = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    #endif
    
    public func scan() -> [FileInfo]? {
        return scanDirectory(FileManager.Home)
    }
    
    public func scanSibling(_ sibling: FileInfo) -> [FileInfo]? {
        var path = sibling.path
        let url = URL(fileURLWithPath: sibling.path)
        guard let range = path.range(of: url.lastPathComponent)
            else {
                return [sibling]
        }
        path.removeSubrange(range)
        return scanDirectory(path)
    }
    
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
}

extension FileManager.FileInfo : Equatable {
    
    public static func == (lhs: FileManager.FileInfo, rhs: FileManager.FileInfo) -> Bool {
        return lhs.name == rhs.name && lhs.pathExtension == rhs.pathExtension && lhs.size == rhs.size && lhs.date == rhs.date
    }

}
