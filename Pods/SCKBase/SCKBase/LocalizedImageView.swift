//
//  LocalizedImageView.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-19.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class ImageCache {
    static public let main = ImageCache()
    open let locations = NSCache<NSString, AnyObject>()
    open let profilePics = NSCache<NSString, AnyObject>()
}

open class LocalizedImageView: ImageView {
    
    fileprivate let picsThread = DispatchQueue(
        label: "SCKBASE.PICS.PARSE",
        attributes: .concurrent)
    
    public var currentURLString : String?
    
    open var shouldUseEmptyImage = true
    
    private var urlStringForChecking: String?
    
    public func loadFrom(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        currentURLString = urlString
        //image = nil
        picsThread.async(group: nil, qos: .unspecified, flags: .barrier) {
            if let imgFromCache = ImageCache.main.locations.object(forKey: urlString as NSString) as? UIImage {
                DispatchQueue.main.async {
                    self.image = imgFromCache
                    self.contentMode = .scaleAspectFill
                }
                return
            }
            DefaultNetwork.operation.performRequestForData(url: url, { (code, message, d) in
                guard let imageToCache = UIImage(data: d) else {
                    print("CDN IMG FAIL ERROR: failed to generate uiimage from \(urlString)")
                    return
                }
                DispatchQueue.main.async(execute: {
                    if self.currentURLString == urlString {
                        self.image = imageToCache
                        self.contentMode = .scaleAspectFill
                    }
                })
                self.picsThread.async {
                    ImageCache.main.locations.setObject(imageToCache, forKey: urlString as NSString)
                }
            }) { (reason) in
                print("CDN IMG FAIL ERROR: failed to fetch image at \(urlString)")
            }
        }
    }
    
    public func loadProfilePicImageFromURL(string: String) {
        guard let url = URL(string: string) else {
            return
        }
        currentURLString = string
        image = nil
        if let imgFromCache = ImageCache.main.profilePics.object(forKey: string as NSString) as? UIImage {
            self.image = imgFromCache
            return
        }
        DefaultNetwork.operation.performRequestForData(url: url, { (code, message, d) in
            DispatchQueue.main.async(execute: {
                guard let imageToCache = UIImage(data: d) else {
                    print("CDN IMG FAIL ERROR: failed to generate uiimage from \(string)")
                    return
                }
                if self.currentURLString == string {
                    self.image = imageToCache
                }
                ImageCache.main.locations.setObject(imageToCache, forKey: string as NSString)
            })
        }) { (reason) in
            print("CDN IMG FAIL ERROR: failed to fetch image at \(string)")
        }
    }
}
