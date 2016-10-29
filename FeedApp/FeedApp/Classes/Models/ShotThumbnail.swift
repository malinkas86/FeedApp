//
//  ShotThumbnail.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit
import CoreData

class ShotThumbnail: NSManagedObject {
    @NSManaged var small: String
    @NSManaged var medium: String
    @NSManaged var large: String
    @NSManaged weak var shotCard: ShotCard!

    func setValuesFromDictionary (shotThumbnail : ShotThumbnail, dictionary : [String : String]) -> ShotThumbnail {
        for (key, value) in dictionary {
            if (shotThumbnail.respondsToSelector(NSSelectorFromString(key))) {
                shotThumbnail.setValue(value, forKey: key)
            }
            
        }
        return shotThumbnail
    }
}
