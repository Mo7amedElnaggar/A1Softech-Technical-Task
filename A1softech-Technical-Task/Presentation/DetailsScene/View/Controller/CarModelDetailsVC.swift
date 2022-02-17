//
//  CarModelDetailsVC.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/17/22.
//

import UIKit

class CarModelDetailsVC: UIViewController {
    deinit { print("\(self.className) deinit") }    

    var makeNiceName: String!, modelNiceName: String!
    var carsDetailsViewModel: CarDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        carsDetailsViewModel = CarDetailsViewModel(makeNiceName: makeNiceName,    modelNiceName: modelNiceName)
        
        loadStyles()
    }
    
    
    func loadStyles() {
        carsDetailsViewModel?.getModelStyles()
    }
}
