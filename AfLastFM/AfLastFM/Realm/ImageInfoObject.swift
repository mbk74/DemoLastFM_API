//
//  ImageInfoObject.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import RealmSwift

class ImageInfoObject: Object {
    @objc dynamic var small: String?
    @objc dynamic var medium: String?
    @objc dynamic var large: String?
    @objc dynamic var extralarge: String?
    
    convenience init(imageInfo: ImageInfo){
        self.init()
        self.small = imageInfo.small?.absoluteString
        self.medium = imageInfo.medium?.absoluteString
        self.large = imageInfo.large?.absoluteString
        self.extralarge = imageInfo.extralarge?.absoluteString
    }
}
