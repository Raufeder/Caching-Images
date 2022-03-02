//
//  PhotoModelDataService.swift
//  SwiftfulThinking
//
//  Created by Derek Raufeisen on 2/28/22.
//

import Foundation
import Combine

class PhotoModelDataService {
    
    static let instance = PhotoModelDataService() // Singleton Instance of this Function
    @Published var photoModels: [PhotoModel] = [] //Initial State of the Photo Model Object
    var cancellables = Set<AnyCancellable>() //Able to cancel requests to clear hard drive space
    
    private init() { //private means we cant call it outside this file
        downloadData() //calling func
    }
    
    func downloadData() { //Fetch Function
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return } //create URl variable
        
        URLSession.shared.dataTaskPublisher(for: url) //Fetch Data
            .subscribe(on: DispatchQueue.global(qos: .background)) // Fetches data in the background
            .receive(on: DispatchQueue.main) //Get data on hte main thread
            .tryMap(handleOutput) // Mapping the data with the function below
            .decode(type: [PhotoModel].self, decoder: JSONDecoder()) //Decoding said data from the HandleOutput Func
            .sink { (completion) in //Checking to make sure we got data
                switch completion {
                case .finished: //Setting Fetch to Finished
                    break
                case .failure(let error): // Error Case
                    print("Error downloading data. \(error)")
                }
            } receiveValue: { [weak self] (returnedPhotoModels) in //Have the Photo Data
                self?.photoModels = returnedPhotoModels // Setting the PhotoModel to the returned Photo Data
            }
            .store(in: &cancellables) //stores Our data, and cancelles to free up space
    }
    
    //Maps Output of data from fetch
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data { //using the URL data as the parameter
        guard // swift for try
            let response = output.response as? HTTPURLResponse, //make sure the response is an HTTP response
            response.statusCode >= 200 && response.statusCode < 300 else { // make sure status code is OK
            throw URLError(.badServerResponse) // if server status is bad, throw error
        }
        return output.data //
    }
    
}
