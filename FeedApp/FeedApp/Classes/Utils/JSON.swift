//
//  JSON.swift
//  FeedApp
//
//  Created by Malinka S on 9/24/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class JSON: NSObject {
    //Parse JSON string to dictionary
    static func parseStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

}
