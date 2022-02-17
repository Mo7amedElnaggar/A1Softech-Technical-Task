//
//  NSObject+ClassName.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/14/22.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
