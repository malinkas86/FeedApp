//
//  Device.swift
//  FeedApp
//
//  Created by Malinka S on 9/24/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit

class Device: NSObject {
    //Returns the device UID
    static func getDeviceUUID () -> String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }

}
