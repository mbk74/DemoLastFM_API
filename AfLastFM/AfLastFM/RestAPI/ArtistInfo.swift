//
//  ArtistInfo.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

public struct ArtistInfo: Decodable {
    public let name: String
    public let listeners: Int
    public let mbid: String?
    public let url: URL
    public let image: ImageInfo
    public let streamable: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case listeners
        case mbid
        case url
        case image
        case streamable
    }

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        name = try root.decode(String.self, forKey: .name)
        listeners = try root.decode(StringMapping<Int>.self, forKey: .listeners).decoded
        mbid = try root.decodeIfPresent(String.self, forKey: .mbid)
        url = try root.decode(URL.self, forKey: .url)
        image = try root.decode(ImageUrlMapping.self, forKey: .image).decoded
        streamable = try root.decode(String.self, forKey: .streamable)
    }
}
