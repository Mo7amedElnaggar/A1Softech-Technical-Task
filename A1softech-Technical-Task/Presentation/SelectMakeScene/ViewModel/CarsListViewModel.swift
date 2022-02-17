//
//  CarsListViewModel.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/14/22.
//

import Foundation
import RxSwift
import RxCocoa

class CarsListViewModel {
    
    var isLoadingBehavior = BehaviorRelay(value: false)

    var carsSubject = PublishSubject<[Vehicle]>()
    
    private var loadedCars: [Vehicle] = []
    private var currentPage = 1, isPrefetching = false
    
    func loadNextVehiclesPage() {
        guard !isPrefetching else { return }
        
        isPrefetching = true
        self.isLoadingBehavior.accept(true)
        
        let paramters: [String: Any] = [
            "api_key": Constants.APIKey,
            "pageNum": currentPage,
            "pageSize": 20,
            "sortby": "ASC"
        ]
        
        print("Current Page", currentPage)
        currentPage += 1
        
        APIService.shared.loadResponse(url: Constants.getMakes, parameters: paramters) { (base: BaseModel<[Vehicle]>?, error: Error?) in
            self.isLoadingBehavior.accept(false)

            // If you receive list of vehicles, just stop prefetching
            // If You didnt receive isPrefetching is Still enable to prevent reloading new page
            if let vehiclesCount = base?.results.count,
               vehiclesCount > 0 {
                self.isPrefetching = false
            }
            
            if let cars = base?.results {
                self.loadedCars.append(contentsOf: cars)
                // Load Cars for the first page
                self.carsSubject.onNext(self.loadedCars)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}
