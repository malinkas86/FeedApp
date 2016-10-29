//
//  FeedCollectionViewCell.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //Sets the shotCard data for display
    func setShotCardData(shotCard : ShotCard){
        heartCountLabel.text = String(format: "%@ likes", shotCard.heartCount)
        let imageURL:String=shotCard.shotThumbnail.small
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //Caches the image
            ImageCache.sharedInstance.cacheImage(imageURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                //Retreives the cached image
                self.imageView.image=ImageCache.sharedInstance.getCachedImage(imageURL)
            }
            
            
        })
        
        
        let queue = NSOperationQueue()
        
        
        queue.addOperationWithBlock { () -> Void in
            //let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView.image = ImageCache.sharedInstance.getCachedImage(imageURL)
            })
            
        }
        
        
        
        let operation1 = NSBlockOperation(block: {
            //let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView.image = ImageCache.sharedInstance.getCachedImage(imageURL)
            })
        })
        
        operation1.completionBlock = {
            
        }
        
    }
}
