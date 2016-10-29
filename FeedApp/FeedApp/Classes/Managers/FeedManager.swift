//
//  FeedManager.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//  Manages all operations regarding the feeds

import UIKit

class FeedManager: NSObject {
    
    let coreDataUtility = FeedCoreDataUtility()
    var delegate : ResponseDelegate?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //get the new feed from the web service
    func getUpdatedFeed(page : String!){
        //get the modified URL based on the page
        let url : String = getModifiedURL(page)
        var params = [String : String]()
        //arrange the parameters based on the request/page
        if page == Constants.DEFAULT_PAGE_VALUE {
            params = ["count":Configuration.sharedInstance.defaultPageCount!]
        }else {
            params = ["count":Configuration.sharedInstance.defaultPageCount!,"page" : page]
        }
        APIClient.request(Constants.REQUEST_TYPE_GET, url: url, params: params){ (status:Bool,responseData: [String:AnyObject]) -> () in
            if status {
                if page == Constants.DEFAULT_PAGE_VALUE {
                    //if this is the initial request, saves the checksum value in user defaults
                    if let checksum = responseData["checksum"] as! String! {
                        UserDefaults.sharedInstance.checksum = checksum
                    }
                    if let dictionary = responseData["groups"] as! [[String : AnyObject]]! {
                        //The success response is sent to the delegate method
                        if self.delegate != nil {
                            self.delegate?.successResponse(Constants.REQUEST_TYPE_GET_FEED, data: self.coreDataUtility.initAndSaveFeed(dictionary[0]))
                        }
                        
                    }
                }else{
                    if self.delegate != nil {
                        self.delegate?.successResponse(Constants.REQUEST_TYPE_GET_FEED, data: self.coreDataUtility.initAndSaveFeed(responseData))
                    }
                }
                
            }else{
                //The fail response is sent to the delegate method
                if self.delegate != nil {
                    self.delegate?.failureResponse(Constants.REQUEST_TYPE_GET_FEED, data: "Error Ocurred")
                }
            }
            
        }
    }
    
    //Check if the server has a new feed list
    func checkForUpdatedFeed(){
        let url : String = getModifiedURL(Constants.DEFAULT_PAGE_VALUE)
        
        let params = ["count":Configuration.sharedInstance.defaultPageCount!]
        
        APIClient.request(Constants.REQUEST_TYPE_GET, url: url, params: params){ (status:Bool,responseData: [String:AnyObject]) -> () in
            if status {
                //sends the comparison of the checksum value as the result
                if let checksum = responseData["checksum"] as! String! {
                    if self.delegate != nil {
                        self.delegate?.successResponse(Constants.REQUEST_TYPE_CHECK_UPDATES, data: checksum == UserDefaults.sharedInstance.checksum)
                    }
                }else{
                    if self.delegate != nil {
                        self.delegate?.failureResponse(Constants.REQUEST_TYPE_CHECK_UPDATES, data: "Error Ocurred")
                    }
                }
                
                
            }else{
                if self.delegate != nil {
                    self.delegate?.failureResponse(Constants.REQUEST_TYPE_CHECK_UPDATES, data: "Error Ocurred")
                }
            }
            
        }
    }
    
    //in order to delete all the current feed records
    func deleteAll(){
        coreDataUtility.deleteAllRecords()
        if self.delegate != nil {
            self.delegate?.successResponse(Constants.REQUEST_TYPE_DELETE_RECORDS, data: true)
        }
    }
    
    
    //Retreives the feed from local storage based on the page
    func getFeedFromLocalStorage(page : String) {
        if let feed : Feed = coreDataUtility.getFeedById(page) {
            if self.delegate != nil {
                self.delegate?.successResponse(Constants.REQUEST_TYPE_GET_FEED, data: feed)
            }
        }else{
            getUpdatedFeed(page)
        }
        
        
    }
    
    //Returns the modified URL based on the page
    private func getModifiedURL(page : String) -> String{
        var url: String = ""
        if page == Constants.DEFAULT_PAGE_VALUE {
            url = Constants.DEFAULT_FEED_URL
        }else{
            url = String(format: Constants.PAGINATED_FEED_URL, UserDefaults.sharedInstance.feedId)
        }
        return url
    }

}
