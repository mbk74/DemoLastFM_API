//
//  TrackInfoObject.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/23/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import RealmSwift

class TrackInfoObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""

    override static func primaryKey() -> String? {
           return "id"
    }
    
    convenience init(track: TrackInfo) {
           self.init()
           self.id = UUID().uuidString
           self.name = track.name
           self.url = track.url.absoluteString
    }

}
