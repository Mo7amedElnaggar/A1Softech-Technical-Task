//
//  CarPhotosViewModel.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/17/22.
//

import Foundation

class CarPhotosViewModel {
    
    let carModels: [CarModel]
    
    init(carModels: [CarModel]) {
        self.carModels = carModels
    }
    
    func loadCurrentPageModelsPhoto(completion: @escaping ((_ models: [CarModel]) -> Void)) {
        let dispatchGroup = DispatchGroup()
        var result: [CarModel] = []
        carModels.forEach { (model) in
            if let makeName = model.makeName,
                  let modelName = model.name {
                dispatchGroup.enter()
                self.loadSpecificModelPhotoUrl(makeName: makeName, modelName: modelName) { (photoUrl) in
                    dispatchGroup.leave()
                    result.append(CarModel(id: model.id,
                                           makeName: model.makeName,
                                           makeNiceName: model.makeNiceName,
                                           name: model.name,
                                           photoUrl: photoUrl))
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("FINISHED")
            completion(result)
        }
    }
    
    func loadSpecificModelPhotoUrl(makeName: String, modelName: String, completion: @escaping ((_ photoUrl: String?) -> Void)) {
        let parameters: [String : Any] = [
            "api_key": Constants.APIKey
        ]
       
        let url = "\(Constants.getPhotos)\(makeName)/\(modelName)/2022/photos"
            .replacingOccurrences(of: " ", with: "_")
        
        APIService.shared.loadResponse(url: url, parameters: parameters) { (photos: ModelPhotos?, error) in
            if let photo = photos?.photos.first?.sources.first?.link.photoUrl {
                completion(Constants.mediaBaseUrl + photo)
            } else {
                completion(nil)
            }
        }
    }
}
