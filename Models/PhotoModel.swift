//
//  PhotoModel.swift
//  SwiftfulThinking
//
//  Created by Derek Raufeisen on 2/28/22.
//

import Foundation

struct PhotoModel: Identifiable, Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

// The Purpose of thise file is to give the data something to attach itself to. varaible must be EXACTLY as you see them in the JSON file. Making it Identifiable and Codable makes it able to see and be seen by other files. This is what we pull from to actually show the data. we set the Fetch to the photoModel

//What Json Output Looks Like
/*
 
 {
     "albumId": 1,
     "id": 1,
     "title": "accusamus beatae ad facilis cum similique qui sunt",
     "url": "https://via.placeholder.com/600/92c952",
     "thumbnailUrl": "https://via.placeholder.com/150/92c952"
   }
 
 */
