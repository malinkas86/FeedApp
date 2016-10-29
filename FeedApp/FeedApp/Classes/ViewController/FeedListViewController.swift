//
//  FeedListViewController.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController, ResponseDelegate, UICollectionViewDataSource {

    var isInitialRequest : Bool = true
    let feedManager = FeedManager()
    //Contains the shotCard data for retreived
    var shotCardData : [ShotCard] = []
    private let reuseIdentifier = "FeedCollectionViewCell"
    
    var iphoneRowCount : CGFloat!
    var ipadRowCount: CGFloat!
    let minimumInteritemSpacing: CGFloat = 1
    var cacheIndexCount: Int = 1
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var bactToTopButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favourites"
        
        //setting the delegate to receive responses from Feed Manager
        feedManager.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout

        //read iphone row count value from configuration
        if let formattedNumber = NSNumberFormatter().numberFromString(Configuration.sharedInstance.iphoneRowCount!) {
            iphoneRowCount = CGFloat(formattedNumber)
        }
        //read ipad row count value from configuration
        if let formattedNumber = NSNumberFormatter().numberFromString(Configuration.sharedInstance.ipadRowCount!) {
            ipadRowCount = CGFloat(formattedNumber)
        }
        //get default feed to start with
        getDefaultFeed()
        //run in the background to check if any updates are available in every 5 minutes
        NSTimer.scheduledTimerWithTimeInterval(300, target:self, selector: #selector(FeedListViewController.checkForUpdatedFeed), userInfo: nil, repeats: true)

        
        
    }
    
    override func viewDidAppear(animated: Bool){
        refreshButton.hidden = true;
        isInitialRequest = false
        self.bactToTopButton.hidden = true
        if !isInitialRequest {
            checkForUpdatedFeed()
        }
        controlActivityIndicatorView(false)
        
    }
    
    // MARK: - Functional methods
    
    //This will check  if any updates are available
    func checkForUpdatedFeed(){
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.feedManager.checkForUpdatedFeed()
            
        })
    }
    
    //Retrieve the default feed
    //The page value will be set for "default"
    func getDefaultFeed(){
        controlActivityIndicatorView(true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.feedManager.getFeedFromLocalStorage(Constants.DEFAULT_PAGE_VALUE)
            
        })
        
        UserDefaults.sharedInstance.pageId = Constants.DEFAULT_PAGE_VALUE
    }
    
    //Retreive paginated data
    //use the next page value from user defaults
    func getPaginatedShotCardData(){
        controlActivityIndicatorView(true)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.feedManager.getFeedFromLocalStorage(UserDefaults.sharedInstance.nextPage)
            
        })
 
    }
    
    // MARK: - Response delgate methods
    
    func successResponse(type: String, data: AnyObject) {
        if type == Constants.REQUEST_TYPE_GET_FEED {
            let feed = data as! Feed
            
            print(feed.pageId)
            //saves the nextpage value in user defaults
            UserDefaults.sharedInstance.nextPage = feed.nextPage
            //saves the feedId in user defaults
            UserDefaults.sharedInstance.feedId = feed.feedId
            
            //If this request is not the default feed retreival,
            //the next page value will be assigned to page Id value
            if !isInitialRequest {
                
                UserDefaults.sharedInstance.pageId = feed.nextPage
                
            }
            //the retreived data will be appended to the shotCardData array
            let newFeedShotCards = Array(feed.shotCards) as! [ShotCard]
            self.shotCardData.appendContentsOf(newFeedShotCards)
            print(self.shotCardData.count)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
                self.controlActivityIndicatorView(false)
            }
            
        }else if type == Constants.REQUEST_TYPE_CHECK_UPDATES {
            let status = data as! Bool
            //If any updates are available
            //the refresh button will be visible for new updates
            if status {
                 self.refreshButton.hidden = true
                
            }
        }else if type == Constants.REQUEST_TYPE_DELETE_RECORDS {
            shotCardData = []
            cacheIndexCount = 0
            getDefaultFeed()
            ImageCache.sharedInstance.clearCache()
            controlActivityIndicatorView(false)
            
        }
    }
    
    func failureResponse(type: String, data: AnyObject) {
        //Handle error situtations
        print(type+": Error occurred while performing the transaction")
    }
    
    // MARK: - Collection View delegate methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotCardData.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(FeedCollectionViewCell.self), forIndexPath: indexPath) as! FeedCollectionViewCell
        
        let shotCard = shotCardData[indexPath.row]
        
        cell.setShotCardData(shotCard)
        
        return cell
    }
    
    //handle transitioning from one layout to another
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width : CGFloat = 0
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            width = (collectionView.bounds.size.width-((iphoneRowCount-1)*minimumInteritemSpacing))/iphoneRowCount
        }else {
            width = (collectionView.bounds.size.width-((ipadRowCount-1)*minimumInteritemSpacing))/ipadRowCount
        }
        
        let height = width*3/2
        return CGSizeMake(width, CGFloat(height))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let shotCard=self.shotCardData[indexPath.row]
        showVideoPlayerPopup (shotCard)
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == self.shotCardData.count - 5
        {
            //based on the device type, the caching is cleared to ensure the app is not running
            //out of memory
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
                if (self.shotCardData.count) > (Int(iphoneRowCount)*100)*cacheIndexCount {
                    ImageCache.sharedInstance.clearCache()
                    cacheIndexCount = cacheIndexCount + 1
                }
            }else {
                if (self.shotCardData.count) > (Int(ipadRowCount)*100)*cacheIndexCount {
                    ImageCache.sharedInstance.clearCache()
                    cacheIndexCount = cacheIndexCount + 1
                }
            }
            
            //Enables infinite scrolling
            self.getPaginatedShotCardData()
            
        }
        //if the current cell has reached a value of more than the default page count
        //the "back to top" button will appear
        if indexPath.row > Int(Configuration.sharedInstance.defaultPageCount!)!  {
            bactToTopButton.hidden = false
        }
        
    }
    
    
    
    // MARK: - Layout
    
    //Ensures the layout remains the same even when the orientation changes
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
    }

    
    // Mark: - Control actions
    
    
    @IBAction func refreshButtonAction(sender: AnyObject) {
        feedManager.deleteAll()
    }
    
    @IBAction func backToTopAction(sender: AnyObject) {
        self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        bactToTopButton.hidden = true
        
    }
    
    
    @IBAction func refreshBarButtonAction(sender: AnyObject) {
        feedManager.deleteAll()
    }
    
    
    //Shows video popup view controller
    //Sets shotcard data
    func showVideoPlayerPopup (shotCard : ShotCard) {
        let videPlayerPopup = UIStoryboard(name: "Feeds", bundle: nil).instantiateViewControllerWithIdentifier("VideoPlayerPopup") as! VideoPopupViewController
        self.addChildViewController(videPlayerPopup)
        videPlayerPopup.view.frame = self.view.frame
        self.view.addSubview(videPlayerPopup.view)
        videPlayerPopup.didMoveToParentViewController(self)
        videPlayerPopup.setShotCardDataAndPlayVideo(shotCard)
    }
    
    func controlActivityIndicatorView(show : Bool){
        if show {
            self.activityIndicatorView.startAnimating()
            self.activityIndicatorView.hidden = false
        }else{
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        ImageCache.sharedInstance.clearCache()
    }

}
