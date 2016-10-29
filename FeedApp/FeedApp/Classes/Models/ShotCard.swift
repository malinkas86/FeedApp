//
//  ShotCard.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit
import CoreData

class ShotCard: NSManagedObject {

    @NSManaged var shotCardId: String
    @NSManaged var videoId: String
    @NSManaged var heartCount: NSNumber
    @NSManaged var playMp4: String
    @NSManaged weak var feed: Feed!
    @NSManaged var shotThumbnail: ShotThumbnail!
    
    func setValuesFromDictionary (shotCard : ShotCard, dictionary : [String : AnyObject]) -> ShotCard {
        for (key, value) in dictionary {
            if (shotCard.respondsToSelector(NSSelectorFromString(key))) {
                if let keyValue = value as? String {
                    shotCard.setValue(keyValue, forKey: key)
                }
            }
            
        }
        
        if let playDictionary = dictionary["play"] as! [String:String]! {
            shotCard.playMp4 = playDictionary["mp4"] as String!
        }else{
            shotCard.playMp4 = ""
        }
        
        if let hearCount = dictionary["heartCount"] as! NSNumber! {
            shotCard.heartCount = hearCount
        }else{
            shotCard.heartCount = 0
        }
        
        return shotCard
    }
}
