//
//  FeedCoreDataUtility.swift
//  FeedApp
//
//  Created by Malinka S on 9/27/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit
import CoreData

class FeedCoreDataUtility: CoreDataUtility {
    func initAndSaveFeed(dictionary : [String : AnyObject]) -> Feed {
        
        
        var feed = Feed(entity: getEntityDescription("Feed"),insertIntoManagedObjectContext: managedObjectContext) as Feed
        
        feed = feed.setValuesFromDictionary(feed, dictionary: dictionary)
        if let pageId = UserDefaults.sharedInstance.pageId as String! {
            feed.pageId = pageId
        }
        
        
        if let cardsDictionary = dictionary["cards"] as! [[String : AnyObject]]! {
            
            var shotCardArray = [ShotCard]()
            
            for cardDictionary in cardsDictionary {
                
                
                let shotCardDictionary = (cardDictionary["shotCardData"] == nil || cardDictionary["shotCardData"] is NSNull) ? nil : cardDictionary["shotCardData"] as! [String : AnyObject]!
                
                let shotCard = initShotCard(shotCardDictionary)
                
                shotCardArray.append(shotCard)
                
                
                
            }
            feed.shotCards=NSSet(array: shotCardArray)
            
        }
        
        saveContext()
        
        return getFeedById(UserDefaults.sharedInstance.pageId)!
    }
    
    //initializes the shotCard
    func initShotCard(dictionary : [String : AnyObject]) -> ShotCard {
        var shotCard = ShotCard(entity: getEntityDescription("ShotCard"),insertIntoManagedObjectContext: managedObjectContext) as ShotCard
        
        
        shotCard = shotCard.setValuesFromDictionary(shotCard, dictionary: dictionary)
        if let shotThumbnailDictionary = dictionary["shotThumbnail"] as! [String:String]! {
            shotCard.shotThumbnail = initShortThumbnail(shotThumbnailDictionary)
        }
        
        
        return shotCard
    }
    
    //initializes the shotThumbnail
    func initShortThumbnail (dictionary : [String:String]) -> ShotThumbnail {
        
        var shotThumbnail = ShotThumbnail(entity: getEntityDescription("ShotThumbnail"),insertIntoManagedObjectContext: managedObjectContext) as ShotThumbnail
        
        
        shotThumbnail = shotThumbnail.setValuesFromDictionary(shotThumbnail, dictionary: dictionary)
        return shotThumbnail
    }
    
    
    
    
    //returns the feed based on the page ID
    func getFeedById(pageId : String) -> Feed? {
        
        let request = NSFetchRequest()
        request.entity = getEntityDescription("Feed")
        
        let pred = NSPredicate(format: "(pageId = %@)", pageId)
        request.predicate = pred
        
        var feeds : [Feed] = []
        
        do {
            let objects = try managedObjectContext.executeFetchRequest(request)
            
            feeds = objects as! [Feed]
            
            
        }catch _ {
            print("Error occurred while retreiving feeds")
        }
        return (feeds.count==1) ? feeds[0] : nil
        
        
    }
    
    // Delete all the records
    func deleteAllRecords(){
        let request = NSFetchRequest()
        request.entity = getEntityDescription("Feed")
        
        
        do {
            var objects = try managedObjectContext.executeFetchRequest(request)
            
            for bas: AnyObject in objects
            {
                managedObjectContext.deleteObject(bas as! NSManagedObject)
            }
            
            objects.removeAll(keepCapacity: false)
            
            
            try managedObjectContext.save()
            
            
        }catch _ {
            print("Error occurred while deleting")
        }
        
        
        
    }
}
