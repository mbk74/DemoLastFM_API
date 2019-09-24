//
//  ImageUrlMapping.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/21/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation

struct ImageUrlMapping: Decodable {
    var decoded: ImageInfo

    private struct ImageInfoMapping: Decodable {
        let text: String
        let size: String

        enum CodingKeys: String, CodingKey {
            case text = "#text"
            case size
        }
    }

    init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        var small: URL?
        var medium: URL?
        var large: URL?
        var extralarge: URL?
        var mega: URL?
        while !unkeyedContainer.isAtEnd {
            let image = try unkeyedContainer.decode(ImageInfoMapping.self)
            let url = URL(string: image.text)
            switch image.size {
            case "small":
                small = url
            case "medium":
                medium = url
            case "large":
                large = url
            case "extralarge":
                extralarge = url
            case "mega":
                mega = url
            default:
                debugPrint("Unknown image size: \(image.size)")
            }
        }

        self.decoded = ImageInfo(small: small, medium: medium, large: large, extralarge: extralarge, mega: mega)
    }
}
