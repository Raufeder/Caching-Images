//
//  PhotoModelFileManager.swift
//  SwiftfulThinking
//
//  Created by Derek Raufeisen on 2/28/22.
//

import Foundation
import SwiftUI

class PhotoModelFileManager {
    
    static let instance = PhotoModelFileManager()
    let folderName = "downloadsFromProofOfConcept" //Name of folder on local device to have the Images stored in
    
    private init() {
        createFolderIfNeeded() //Calling the creafte folder function
    }
    
    private func createFolderIfNeeded() { //functo create folder if folder does'nt already exist
        guard let url = getFolderPath() else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) { //If the filepath with the given URL doesnt exist yet
            do {
                try FileManager.default.createDirectory(at: url,  withIntermediateDirectories: true, attributes: nil) //creates an empty directory if it doesnt already exist
                print("Created folder!")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    private func getFolderPath() -> URL? { //all this entire function does is get the location of the folder we are about to add with the create folder function. expected behavior Below
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    //   ... /downloaded_photos/
    //   ... /downloaded_photos/image_name.png
    private func getImagePath(key: String) -> URL? { //This func puts the proper tag on each of the iamge files, and adds a path for each one to grab later with gets
        guard let folder = getFolderPath() else {
            return nil
        }
        return folder.appendingPathComponent(key + ".png") //The key is the image name so all saved iamgess should be the structure listed above
    }
    
    func add(key: String, value: UIImage) { //Func to add an image to the Image path
        guard
            let data = value.pngData(), //
            let url = getImagePath(key: key) else { return } //where to add it
        
        do {
            try data.write(to: url) //adding it to the given url
        } catch let error {
            print("Error saving to file manager. \(error)")
        }
    }
    
    func get(key: String) -> UIImage? { //Func to get already Existsing Images
        guard
            let url = getImagePath(key: key), //URL
            FileManager.default.fileExists(atPath: url.path) else { //Check for If File Exists
            return nil
        }
        return UIImage(contentsOfFile: url.path) //Get the Image with hthe current key
    }
    
    
}
