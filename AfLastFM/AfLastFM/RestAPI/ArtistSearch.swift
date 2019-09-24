//
//  ArtistSearch.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

public struct ArtistSearchResponse: Decodable {
    public let query: OpenSearchQuery
    public let totalResults: Int
    public let startIndex: Int
    public let itemsPerPage: Int
    public let artistInfos: [ArtistInfo]
    
    private enum CodingKeys: String, CodingKey {
        case query = "opensearch:Query"
        case totalResults = "opensearch:totalResults"
        case startIndex = "opensearch:startIndex"
        case itemsPerPage = "opensearch:itemsPerPage"
        case artistContainer = "artistmatches"
    }
    
    private enum ArtistContainerKeys: String, CodingKey {
        case artist
    }
    
    private enum SearchKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: SearchKeys.self)
        let results = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        query = try results.decode(OpenSearchQuery.self, forKey: .query)
        totalResults = try results.decode(StringMapping<Int>.self, forKey: .totalResults).decoded
        startIndex = try results.decode(StringMapping<Int>.self, forKey: .startIndex).decoded
        itemsPerPage = try results.decode(StringMapping<Int>.self, forKey: .itemsPerPage).decoded
        let artists = try results.nestedContainer(keyedBy: ArtistContainerKeys.self, forKey: .artistContainer)
        artistInfos = try artists.decode([ArtistInfo].self, forKey: .artist)
    }
}
