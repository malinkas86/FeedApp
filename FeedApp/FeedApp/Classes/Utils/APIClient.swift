//
//  APIClient.swift
//  FeedApp
//
//  Created by Malinka S on 9/24/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    
    
    
    static func request(type : String, url : String, params : [String:String], completionHandler : (status:Bool,responseData:[String:AnyObject]) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: modifyURLWithParams(type, url: url, params: params))!)
        
        //sets the headers to the request
        request.addValue(Device.getDeviceUUID(), forHTTPHeaderField: Constants.DEVICE_TOKEN_HEADER_KEY)
        request.addValue(Configuration.sharedInstance.clientName!, forHTTPHeaderField: Constants.CLIENT_NAME_HEADER_KEY)
        request.addValue(Configuration.sharedInstance.acceptApplication!, forHTTPHeaderField: Constants.ACCEPT_HEADER_KEY)
        request.addValue(Configuration.sharedInstance.acceptLanguage!, forHTTPHeaderField: Constants.ACCEPT_LANGUAGE_HEADER_KEY)
        
        
        
        // Perform the request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            // Get data as string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as String!
            print(responseString)
            let convertedDict=JSON.parseStringToDictionary(responseString)
            if error != nil {
                completionHandler(status: false,responseData:[Constants.RESPONSE_MESSAGE_KEY:(error?.description)!])
            }
            
            completionHandler(status: true,responseData:convertedDict!)
            return
            
        }
        task.resume()

        
    }
    
    //Modifies the URL based on the request types
    private static func modifyURLWithParams(type : String, url : String, params : [String : String]) -> String {
        var fullURL = String(format: "%@%@%@",Configuration.sharedInstance.feedBaseURL!,url,params.count != 0 && type == Constants.REQUEST_TYPE_GET ? "?" : "")
        
        if type == Constants.REQUEST_TYPE_GET {
            for (key,value) in params {
                fullURL = fullURL + String(format : "%@=%@&",key,value)
            }
        }
        return fullURL
    }

}
