//
//  BaseModel.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/15/22.
//

import Foundation

struct BaseModel<Results: Codable>: Codable {
    var results: Results
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
