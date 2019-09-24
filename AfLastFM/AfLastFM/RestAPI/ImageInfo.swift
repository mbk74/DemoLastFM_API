//
//  Image.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/21/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//


import Foundation

public struct ImageInfo: Decodable {
    public let small: URL?
    public let medium: URL?
    public let large: URL?
    public let extralarge: URL?
    public let mega: URL?
}
