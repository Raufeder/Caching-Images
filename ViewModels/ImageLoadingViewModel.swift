//
//  ImageLoadingViewModel.swift
//  SwiftfulThinking
//
//  Created by Derek Raufeisen on 2/28/22
//

import Foundation
import SwiftUI
import Combine

class ImageLoadingViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    let manager = PhotoModelFileManager.instance //USE THE FILEMANGAER FOR PERSISTING BETWEEN SESSIONS
    // let manager = PhotoModelCacheManager.instance // THIS IS FOR DATA THAT WE DON'T WANT PERSISTING BETWEEN SESSIONS
    let urlString: String
    let imageKey: String
    
    init(url: String, key: String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    func getImage() {
        if let savedImage = manager.get(key: imageKey) {
            image = savedImage
            print("Getting saved image!")
        } else {
            downloadImage()
            print("Downloading image now!")
        }
    }
    
    func downloadImage() {
        isLoading = true //is loading for duration of fetch
        guard let url = URL(string: urlString) else { //
            isLoading = false //error handling
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url) // fetch data
            .map { UIImage(data: $0.data) } //parse through data
            .receive(on: DispatchQueue.main) //recieve on the main thread
            .sink { [weak self] (_) in //Checking to make sure we got data, underscore means all of the data
                self?.isLoading = false //fetch done, stop loading
            } receiveValue: { [weak self] (returnedImage) in // waht to do with recieveed data
                guard
                    let self = self,
                    let image = returnedImage else { return } //if theres an iamge, let it equal returnedImage
                
                self.image = image
                self.manager.add(key: self.imageKey, value: image) //adding thte image to the PhotoModel manager file
            }
            .store(in: &cancellables) //stores Our data, and cancelles to free up space
    }
    
}
