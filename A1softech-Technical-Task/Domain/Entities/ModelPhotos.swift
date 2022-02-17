//
//  ModelPhotos.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/16/22.
//

import Foundation

struct ModelPhotos: Codable {
    let photos: [ModelPhoto]
}

struct ModelPhoto: Codable {
    let sources: [ModelPhotoSource]
}

struct ModelPhotoSource: Codable {
    let link: ModelPhotoLink
}

struct ModelPhotoLink: Codable {
    let photoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case photoUrl = "href"
    }
}
