//
//  TopAlbumInfoList.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

public struct TopAlbumInfoList: Decodable {
     
    public let albums: [TopAlbumInfo]
    public let artist: String
    public let page: Int
    public let perPage: Int
    public let totalPages: Int
    public let total: Int
   
    private enum TopContainerKeys: String, CodingKey {
        case topalbums
    }
    
    private enum ContainerKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
    
    private enum AttributeKeys: String, CodingKey {
        case artist
        case page
        case perPage
        case totalPages
        case total
    }

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: TopContainerKeys.self)
        let container = try root.nestedContainer(keyedBy: ContainerKeys.self, forKey: .topalbums)
        albums = try container.decode([TopAlbumInfo].self, forKey: .album)
        let attrContainer = try container.nestedContainer(keyedBy: AttributeKeys.self, forKey: .attr)
        artist = try attrContainer.decode(String.self, forKey: .artist)
        page = try attrContainer.decode(StringMapping<Int>.self, forKey: .page).decoded
        perPage = try attrContainer.decode(StringMapping<Int>.self, forKey: .perPage).decoded
        totalPages = try attrContainer.decode(StringMapping<Int>.self, forKey: .totalPages).decoded
        total = try attrContainer.decode(StringMapping<Int>.self, forKey: .total).decoded
    }
}
