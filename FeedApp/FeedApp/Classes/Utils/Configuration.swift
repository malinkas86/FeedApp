//
//  Configuration.swift
//  FeedApp
//
//  Created by Malinka S on 9/24/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class Configuration: NSObject {
    
    static let sharedInstance = Configuration()
    
    
    var clientName:String? = ""
    var defaultPageCount : String? = ""
    
    var feedBaseURL : String? = ""
    var ipadRowCount : String? = ""
    var iphoneRowCount : String? = ""
    var acceptLanguage : String? = ""
    var acceptApplication : String? = ""
    
    private override init() {
        super.init()
        //read values configured in the desired config file
        readValuesFromConfig()
    }
    /**
    * Read values configured in the desired config file
    * and assign them to the defined properties
    **/
    private func readValuesFromConfig(){
        var plistDictionary: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("config_default", ofType: "plist") {
            plistDictionary = NSDictionary(contentsOfFile: path)
        }
        if let configDictionary = plistDictionary!["config"] as! [String : String]! {
            
            for (key, value) in configDictionary {
                if (self.respondsToSelector(NSSelectorFromString(key))) {
                    self.setValue(value, forKey: key)
                }
                
            }
            
        }
    }

}
