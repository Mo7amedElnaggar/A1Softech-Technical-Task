//
//  CarModelsViewModel.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/16/22.
//

import Foundation
import RxSwift
import RxCocoa

class CarModelsViewModel {
    
    let carMakeId: Int
    
    init(carMakeId: Int) { self.carMakeId = carMakeId }
        
    private var pageNum = 1, isPrefetchingModels = false
    private var totalCarModels: [CarModel] = []
    
    var isLoadingBehavior = BehaviorRelay(value: false)
    var carModelsSubject = PublishSubject<[CarModel]>()
    var noModelsAvailableBehavior = BehaviorRelay(value: false)
    
    func loadCarModelNextPage() {
        guard !isPrefetchingModels else { return }
        
        isPrefetchingModels = true
        self.isLoadingBehavior.accept(true)
        let parameters: [String : Any] = [
            "api_key": Constants.APIKey,
            "pageNum": pageNum,
            "pageSize": 10,
            "makeId": carMakeId,
            "modelYears.year": 2022,
            "sortby": "ASC",
        ]
        print("Current Page", pageNum)

        APIService.shared.loadResponse(url: Constants.getModels, parameters: parameters) { (result: BaseModel<[CarModel]>?, error) in
            // If you receive list of vehicles, just stop prefetching
            // If You didnt receive isPrefetching is Still enable to prevent reloading new page
            if let modelsCount = result?.results.count,
               modelsCount > 0 {
                self.isPrefetchingModels = false
            }
            // Check if the first page total models count is equal to zero
            // Thus, show alert no models available
            if let models = result?.results,
               models.count == 0 , self.pageNum == 1 {
                self.noModelsAvailableBehavior.accept(true)
                self.isLoadingBehavior.accept(false)
            } else if let models = result?.results {
                self.noModelsAvailableBehavior.accept(false)
                self.downloadPhotoForEachCarModel(models: models)
                self.pageNum += 1
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func downloadPhotoForEachCarModel(models: [CarModel]) {
        let carPhotoViewModel = CarPhotosViewModel(carModels: models)
        carPhotoViewModel.loadCurrentPageModelsPhoto { [weak self] (models) in
            guard let self = self else { return }
            self.isLoadingBehavior.accept(false)
            self.totalCarModels.append(contentsOf: models)
            self.carModelsSubject.onNext(self.totalCarModels)

        }
    }
}
