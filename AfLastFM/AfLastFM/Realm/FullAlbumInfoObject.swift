//
//  FullAlbumInfoObject.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/21/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import RealmSwift

class FullAlbumInfoObject: Object {
     
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var artist: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var image: String = ""
    var trackInfos = List<TrackInfoObject>()
    override static func primaryKey() -> String? {
           return "id"
    }
    
    convenience init(album: FullAlbumInfo) {
        self.init()
        self.id = album.hashValue
        self.name = album.name
        self.artist = album.artist
        self.url = album.url.absoluteString
        self.image = album.image?.absoluteString ?? ""
        self.trackInfos = List<TrackInfoObject>()
        self.trackInfos.append(objectsIn: album.trackInfos.map { TrackInfoObject(track: $0) })
    }
}

extension FullAlbumInfoObject: SimpleAlbumInfo {
    var uid: String { return id }
    var albumTitle: String { return name }
    var albumArtist: String { return artist}
    var imageUrl: URL? { return URL(string: image)}
    var tracks: [String] { return trackInfos.map {$0.name} }
}
