//
//  DownloadingImagesViewModel.swift
//  SwiftfulThinking
//
//  Created by Derek Raufeisen on 2/28/22.
//

import Foundation
import Combine

class DownloadingImagesViewModel: ObservableObject { //Make this function Observable from other files
    
    @Published var dataArray: [PhotoModel] = [] //Initial State of the Photo Model
    var cancellables = Set<AnyCancellable>() //Able to cancel requests to clear hard drive space

    let dataService = PhotoModelDataService.instance //making Varible to use the data from the fetch in this file
    
    init() {
        addSubscribers() //calling func
    }
    
    func addSubscribers() {
        dataService.$photoModels //Calling the Photomodels variable in the Photo Model Data Service. the "$" means we are getting it from a "@Publisher"
            .sink { [weak self] (returnedPhotoModels) in //Checking to make sure we got data
                self?.dataArray = returnedPhotoModels //Setting Data to the dataArray variable
            }
            .store(in: &cancellables) //stores Our data, and cancelles to free up space
    }
    
}
