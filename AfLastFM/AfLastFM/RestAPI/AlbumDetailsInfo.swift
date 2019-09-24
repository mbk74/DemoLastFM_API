//
//  AlbumDetailsInfo.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/23/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

public struct AlbumDetailsInfo: Decodable {

    public let name: String
    public let playcount: Int
    public let mbid: String?
    public let url: URL
    public let artist: String
    public let image: ImageInfo

    private enum CodingKeys: String, CodingKey {
        case name
        case playcount
        case mbid
        case url
        case image
        case artist
    }

    private enum ArtistContainerKeys: String, CodingKey {
        case name
        case mbid
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        name = try root.decode(String.self, forKey: .name)
        playcount = try root.decode(Int.self, forKey: .playcount)
        mbid = try root.decodeIfPresent(String.self, forKey: .mbid)
        url = try root.decode(URL.self, forKey: .url)
        image = try root.decode(ImageUrlMapping.self, forKey: .image).decoded
        let artistContainer = try root.nestedContainer(keyedBy: ArtistContainerKeys.self, forKey: .artist)
        artist = try artistContainer.decode(String.self, forKey: .name)
    }
}

