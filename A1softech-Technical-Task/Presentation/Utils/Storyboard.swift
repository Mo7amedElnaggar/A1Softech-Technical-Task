//
//  Storyboard.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/16/22.
//

import UIKit

enum Storyboard: String {
    case SelectMake
    case SelectModel
    case ModelDetails
    
    func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let viewController = UIStoryboard(name: self.rawValue, bundle: nil).instantiateViewController(withIdentifier: VC.className) as? VC else {
            fatalError("Couldn’t instantiate \(VC.className)")
        }
        return viewController
    }
    
}
