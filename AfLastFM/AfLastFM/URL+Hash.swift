//
//  URL+Hash.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/24/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import Foundation
import CommonCrypto

extension URL {
    func getHash() -> String {
        let data = self.dataRepresentation
        var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))

        let _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, UInt32(data.count), &digest)
        }
        var md5String = ""
        for byte in digest {
            md5String += String(format:"%02x", UInt8(byte))
        }
        
        return md5String
    }
}

protocol MD5Hashable {
    var hashValue: String { get }
}
