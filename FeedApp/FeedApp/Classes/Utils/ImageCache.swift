//
//  ImageCache.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//
//  Manages image cache

import UIKit



class ImageCache: NSObject {
    var cache :NSCache?
    
    static let sharedInstance = ImageCache()
    
    private override init() {
        super.init()
        //read values configured in the desired config file
        cache = NSCache()
    }
    
    func cacheImage(url : String) {
        let image=UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)
        cache!.setObject(image!, forKey: url)
        
    }
    
    func getCachedImage(url : String) -> UIImage{
        return (cache!.objectForKey(url) as? UIImage)!
    }
    
    // clears cache
    func clearCache(){
        cache!.removeAllObjects()
    }
    
}
