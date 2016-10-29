//
//  Constants.swift
//  FeedApp
//
//  Created by Malinka S on 9/24/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

struct Constants {
    //Plist config keys
    static let ACCEPT_LANGUAGE_HEADER_KEY = "Accept-Language"
    static let ACCEPT_HEADER_KEY = "Accept"
    static let DEVICE_TOKEN_HEADER_KEY = "device-token"
    static let CLIENT_NAME_HEADER_KEY = "client-name"
    static let REQUEST_TYPE_GET = "GET"
    static let RESPONSE_MESSAGE_KEY = "message"
    static let DEFAULT_PAGE_VALUE = "default"
    
    //Request URLS
    static let DEFAULT_FEED_URL = "feed/set/featuredShots"
    static let PAGINATED_FEED_URL = "feed/%@"
    
    //Request types
    static let REQUEST_TYPE_GET_FEED = "GET_FEEDS"
    static let REQUEST_TYPE_CHECK_UPDATES = "CHECK_UPDATES"
    static let REQUEST_TYPE_DELETE_RECORDS = "DELETE_RECORDS"
}
