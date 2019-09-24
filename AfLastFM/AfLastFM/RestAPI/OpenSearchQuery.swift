//
//  OpenSearchQuery.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

public struct OpenSearchQuery: Decodable {
    public var text: String
    public var role: String
    public var searchTerms: String
    public var startPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role
        case searchTerms
        case startPage
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        role = try values.decode(String.self, forKey: .role)
        searchTerms = try values.decode(String.self, forKey: .searchTerms)
        startPage = try values.decode(StringMapping<Int>.self, forKey: .startPage).decoded
    }
}
