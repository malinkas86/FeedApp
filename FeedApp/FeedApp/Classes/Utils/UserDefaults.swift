//
//  UserDefaults.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class UserDefaults: NSObject {
    var defaults : NSUserDefaults = NSUserDefaults()
    static let sharedInstance = UserDefaults()
    
    private override init() {
        super.init()
        defaults = NSUserDefaults.standardUserDefaults()
    }
    
    //Encapsulates all the variables
    //and sets to user defaults based on the key
    
    var feedId : String {
        get {
            return defaults.stringForKey("feedId")!
        }
        set (feedId) {
            defaults.setObject(feedId, forKey: "feedId")
        }
    }
    
    var pageId : String {
        get {
            return defaults.stringForKey("pageId")!
        }
        set (pageId) {
            defaults.setObject(pageId, forKey: "pageId")
        }
    }
    
    var nextPage : String {
        get {
            return defaults.stringForKey("nextPage")!
        }
        set (nextPage) {
            defaults.setObject(nextPage, forKey: "nextPage")
        }
    }
    
    var checksum : String {
        get {
            if let checkSumVal = defaults.stringForKey("checksum")! as String! {
                return checkSumVal
            }
            return ""
        }
        set (checksum) {
            defaults.setObject(checksum, forKey: "checksum")
        }
    }

}
