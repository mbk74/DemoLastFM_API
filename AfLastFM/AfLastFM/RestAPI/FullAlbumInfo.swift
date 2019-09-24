//
//  FullAlbumInfo.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/23/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation
import CommonCrypto

public struct TrackInfo: Decodable {
    public let name: String
    public let url: URL
    
    public enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        name = try root.decode(String.self, forKey: .name)
        url = try root.decode(URL.self, forKey: .url)
    }
}

public struct FullAlbumInfo: Decodable {
    public let name: String
    public let artist: String
    public let url: URL
    public let image: URL?
    public let trackInfos: [TrackInfo]
    
    private enum TopContainerKeys: String, CodingKey {
        case album
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case artist
        case url
        case image
        case tracks
    }

    private enum TrackContainerKeys: String, CodingKey {
        case track
    }
    
    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: TopContainerKeys.self)
        let albumContainer = try root.nestedContainer(keyedBy: CodingKeys.self, forKey: .album)
        name = try albumContainer.decode(String.self, forKey: .name)
        artist = try albumContainer.decode(String.self, forKey: .artist)
        url = try albumContainer.decode(URL.self, forKey: .url)
        let images = try albumContainer.decode(ImageUrlMapping.self, forKey: .image).decoded
        image = images.large
        let trackContainer = try albumContainer.nestedContainer(keyedBy: TrackContainerKeys.self, forKey: .tracks)
        trackInfos = try trackContainer.decode([TrackInfo].self, forKey: .track)
    }
}

extension FullAlbumInfo: MD5Hashable {
    public var hashValue: String {
        return url.getHash()
    }
}

extension FullAlbumInfo: SimpleAlbumInfo {
    var uid: String { return hashValue}
    var albumTitle: String { return name }
    var albumArtist: String { return artist}
    var imageUrl: URL? { return image }
    var tracks: [String] { return trackInfos.map {$0.name} }
}
