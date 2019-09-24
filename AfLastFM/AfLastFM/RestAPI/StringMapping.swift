//
//  StringCodableMap.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/21/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

struct StringMapping<T: LosslessStringConvertible>: Codable {
    public private (set) var decoded: T

    init(_ decoded: T) {
        self.decoded = decoded
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(String.self)

        guard let decoded = T(value) else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "The string \(value) can't be representable as a \(T.self)"
            )
        }
        self.decoded = decoded
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(decoded.description)
    }
}
