//
//  CoreDataUtility.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//
//  Manages all the coredata related functionality
//  Currently doesn't dupport multi threaded operations

import UIKit
import CoreData

class CoreDataUtility: NSObject {
//    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - Core Data Stack
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("FeedApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parentContext = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    // MARK: - Helper Methods
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cocoacasts.Core_Data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()


    
    func getEntityDescription(entity : String) -> NSEntityDescription {
        return NSEntityDescription.entityForName(entity,inManagedObjectContext: managedObjectContext)!
    }
    
//    func initAndSaveFeed(dictionary : [String : AnyObject]) -> Feed {
//        
//        
//        var feed = Feed(entity: getEntityDescription("Feed"),insertIntoManagedObjectContext: managedObjectContext) as Feed
//        
//        feed = feed.setValuesFromDictionary(feed, dictionary: dictionary)
//        if let pageId = UserDefaults.sharedInstance.pageId as String! {
//            feed.pageId = pageId
//        }
//        
//        
//        if let cardsDictionary = dictionary["cards"] as! [[String : AnyObject]]! {
//            
//            var shotCardArray = [ShotCard]()
//            
//            for cardDictionary in cardsDictionary {
//                
//                
//                let shotCardDictionary = (cardDictionary["shotCardData"] == nil || cardDictionary["shotCardData"] is NSNull) ? nil : cardDictionary["shotCardData"] as! [String : AnyObject]!
//                
//                let shotCard = initShotCard(shotCardDictionary)
//                
//                shotCardArray.append(shotCard)
//                
//                
//                
//            }
//            feed.shotCards=NSSet(array: shotCardArray)
//            
//        }
//
//        saveContext()
//        return feed
//    }
//    
//    
//    func initShotCard(dictionary : [String : AnyObject]) -> ShotCard {
//        var shotCard = ShotCard(entity: getEntityDescription("ShotCard"),insertIntoManagedObjectContext: managedObjectContext) as ShotCard
//       
//        
//        shotCard = shotCard.setValuesFromDictionary(shotCard, dictionary: dictionary)
//        if let shotThumbnailDictionary = dictionary["shotThumbnail"] as! [String:String]! {
//            shotCard.shotThumbnail = initShortThumbnail(shotThumbnailDictionary)
//        }
//        
//        
//        return shotCard
//    }
//    
//    func initShortThumbnail (dictionary : [String:String]) -> ShotThumbnail {
//        
//        var shotThumbnail = ShotThumbnail(entity: getEntityDescription("ShotThumbnail"),insertIntoManagedObjectContext: managedObjectContext) as ShotThumbnail
//        
//        
//        shotThumbnail = shotThumbnail.setValuesFromDictionary(shotThumbnail, dictionary: dictionary)
//        return shotThumbnail
//    }
//    
//    //returns the feed based on the page ID
//    func getFeedById(pageId : String) -> Feed? {
//        
//        let request = NSFetchRequest()
//        request.entity = getEntityDescription("Feed")
//        
//        let pred = NSPredicate(format: "(pageId = %@)", pageId)
//        request.predicate = pred
//        
//        var feeds : [Feed] = []
//        
//        do {
//            let objects = try managedObjectContext.executeFetchRequest(request)
//            
//            feeds = objects as! [Feed]
//            
//            
//        }catch _ {
//            print("Error occurred while retreiving feeds")
//        }
//        return (feeds.count==1) ? feeds[0] : nil
//        
//        
//    }
//    
//    // Delete all the records
//    func deleteAllRecords(){
//        let request = NSFetchRequest()
//        request.entity = getEntityDescription("Feed")
//        
//        
//        do {
//            var objects = try managedObjectContext.executeFetchRequest(request)
//            
//            for bas: AnyObject in objects
//            {
//                managedObjectContext.deleteObject(bas as! NSManagedObject)
//            }
//            
//            objects.removeAll(keepCapacity: false)
//            
//            
//            try managedObjectContext.save()
//            
//            
//        }catch _ {
//            print("Error occurred while deleting")
//        }
//        
//        
//        
//    }
    
}