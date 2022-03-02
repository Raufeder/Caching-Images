//
//  PhotoModelCacheManager.swift
//  SwiftfulThinking
//
//  Created by Derek Raufeisen on 2/28/22.
//

import Foundation
import SwiftUI

class PhotoModelCacheManager {
    
    static let instance = PhotoModelCacheManager()
    private init() { }
    
    var photoCache: NSCache<NSString, UIImage> = { //Asking NSCache what to look at and waht data it is
        var cache = NSCache<NSString, UIImage>() //
        cache.countLimit = 200 //Limiting the number of Images It can hold
        cache.totalCostLimit = 1024 * 1024 * 200 // Limiting the amount of data it can hold, in this case 200mb
        return cache //return the cache
    }()
    
    func add(key: String, value: UIImage) { //Add func with parameteres
        photoCache.setObject(value, forKey: key as NSString) //adds the UIImage to the pohtocache object with a key to pull from in the get
    }
    
    func get(key: String) -> UIImage? { //Func to get an image rthats already cached
        return photoCache.object(forKey: key as NSString) //retrun a photocache object for teh given key
    }
    
}
