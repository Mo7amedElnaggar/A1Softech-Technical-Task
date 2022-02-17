//
//  CarDetailsViewModel.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/17/22.
//

import Foundation
import RxSwift
import RxCocoa

class CarDetailsViewModel {
    
    var isLoadingBehavior = BehaviorRelay(value: false)
    
    let makeNiceName: String, modelNiceName: String
    
    init(makeNiceName: String, modelNiceName: String) {
        print(makeNiceName)
        print(modelNiceName)
        self.makeNiceName = makeNiceName
        self.modelNiceName = modelNiceName
    }
    
    func getModelStyles() {
        
        let parameters: [String : Any] = [
            "api_key": Constants.APIKey,
            "makeNiceName": makeNiceName,
            "modelNiceName": modelNiceName,
        ]
        
        APIService.shared.loadResponse(url: Constants.getModelStyles, parameters: parameters) { (models: BaseModel<ModelStyle>?, error) in

            print(models?.results ?? [])
        }
        
    }
    
}
