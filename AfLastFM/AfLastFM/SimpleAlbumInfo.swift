//
//  SimpleAlbumInfo.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/23/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

protocol SimpleAlbumInfo {
    var uid: String { get }
    var albumTitle: String { get }
    var albumArtist: String { get }
    var imageUrl: URL? { get }
    var tracks: [String] { get }
}
