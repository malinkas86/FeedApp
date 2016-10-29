//
//  Feed.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit
import CoreData

class Feed: NSManagedObject {
    @NSManaged var checksum: String!
    @NSManaged var feedId: String!
    @NSManaged var nextPage: String!
    @NSManaged var pageId: String!
    @NSManaged var shotCards : NSSet!
    
    func setValuesFromDictionary (feed : Feed, dictionary : [String : AnyObject]) -> Feed {
        for (key, value) in dictionary {
            if (feed.respondsToSelector(NSSelectorFromString(key))) {
                feed.setValue(value, forKey: key)
            }
            
        }
        return feed
    }
}
