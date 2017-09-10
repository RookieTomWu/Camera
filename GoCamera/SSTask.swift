
//
//  SSTask.swift
//  Capture
//
//  Created by ShawnDu on 15/11/24.
//  Copyright © 2015年 ShawnDu. All rights reserved.
//

import UIKit

let kTaskCacheFolder = "TaskCacheFolder"

class SSTask: NSObject {
    
    var image: UIImage?
    fileprivate var imageFileName: String?

    override init() {
        super.init()
        self.createPathIfNeeded()
    }
    
    static func emptyDirectory() {
        let fileManager = FileManager.default
        let folderPath = NSTemporaryDirectory() + "/" + kTaskCacheFolder
        
        if let files = fileManager.subpaths(atPath: folderPath) {
            for fileName in files {
                let fullPath = folderPath + fileName
                do {
                    try fileManager.removeItem(atPath: fullPath)
                } catch {
                }
            }
        }

    }

    //MARK: - public method
    func prepare() {
        self.image = self.loadImage()
    }
    
    func cache() {
        if self.imageFileName == nil {
            self.imageFileName = self.generateFileName()
        }
        if self.image == nil {
            self.prepare()
        }
        self.saveImage(self.image!)
        self.image = nil
    }
    
    func clean() {
        if self.imageFileName != nil {
            self.deleteImage()
        }
        self.image = nil
        self.imageFileName = nil
    }
    
    //MARK: - private method
    fileprivate func loadImage() -> UIImage? {
        
        let path = NSTemporaryDirectory() + "/" + kTaskCacheFolder + self.imageFileName!
        let img = UIImage(contentsOfFile: path)
        return img
    }
    
    fileprivate func generateFileName() -> String {
        let time = Date().timeIntervalSince1970
        let timeStr = String(time)
        return timeStr
    }
    
    fileprivate func saveImage(_ img: UIImage) {
        let path = NSTemporaryDirectory() + "/" + kTaskCacheFolder + self.imageFileName!
        if !FileManager.default.fileExists(atPath: path) {
            let data = UIImageJPEGRepresentation(img, 0.8)
            try? data?.write(to: URL(fileURLWithPath: path), options: [.atomic])
        }
    }
    
    fileprivate func deleteImage() {
        let path = NSTemporaryDirectory() + "/" + kTaskCacheFolder + self.imageFileName!
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("SSTask file manager remove item failed")
            }
        }
    }
    
    fileprivate func createPathIfNeeded() {
        let tmpPath = NSTemporaryDirectory()
        let folderPath = tmpPath + "/" + kTaskCacheFolder
        if !FileManager.default.fileExists(atPath: folderPath) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("SSTask create cache folder failed!")
            }
            
        }
    }
}
