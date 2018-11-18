//
//  UnkeyedDecodingContainer+Safe.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 1/03/18.
//  Copyright © 2018 IdleHandsApps Ltd. All rights reserved.
//

import UIKit

fileprivate struct DummyCodable: Codable {}

// based on this https://stackoverflow.com/a/49685332/4096797
extension UnkeyedDecodingContainer {

    public mutating func decodeArray<T>(_ type: T.Type, doLog: Bool = true) throws -> [T] where T : Decodable {
        
        var array = [T]()
        while !self.isAtEnd {
            do {
                let item = try self.decode(T.self)
                array.append(item)
            } catch {
                // hack to increment currentIndex
                _ = try self.decode(DummyCodable.self)
            }
        }
        return array
    }
}
