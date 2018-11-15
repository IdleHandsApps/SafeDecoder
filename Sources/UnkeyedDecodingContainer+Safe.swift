//
//  KeyedDecodingErrorContainer.swift
//  Neighbourly
//
//  Created by Fraser on 1/03/18.
//  Copyright © 2018 Neighbourly Ltd. All rights reserved.
//

import UIKit

fileprivate struct DummyCodable: Codable {}

// based on this https://stackoverflow.com/questions/46344963/swift-jsondecode-decoding-arrays-fails-if-single-element-decoding-fails
extension UnkeyedDecodingContainer {

    public mutating func decodeArray<T>(_ type: T.Type, doLog: Bool = true) throws -> [T] where T : Decodable {
        
        var array = [T]()
        while !self.isAtEnd {
            do {
                let item = try self.decode(T.self)
                array.append(item)
            } catch let error {
                if doLog {
                    SafeDecoder.logger?(error, String(describing: T.self))
                    //Log.error(": \(error) for type: \(String(describing: T.self))")
                }
                // hack to increment currentIndex
                _ = try self.decode(DummyCodable.self)
            }
        }
        return array
    }
}
