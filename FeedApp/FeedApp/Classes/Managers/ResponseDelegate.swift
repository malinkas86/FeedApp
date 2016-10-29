//
//  ResponseDelegate.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//
//  Defines the status of a response, all classes conforming the protocol will retreve the data based on the
//  mentioned type

import Foundation

protocol ResponseDelegate {
    func successResponse (type : String, data : AnyObject)
    func failureResponse (type : String, data : AnyObject)
}
