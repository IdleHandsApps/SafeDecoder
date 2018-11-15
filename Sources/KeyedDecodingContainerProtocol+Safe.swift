//
//  KeyedDecodingContainerProtocol+Safe.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 1/03/18.
//  Copyright © 2018 IdleHandsApps Ltd. All rights reserved.
//

import UIKit

extension KeyedDecodingContainerProtocol {
    public func decodeArray<T>(_ type: T.Type, forKey key: Self.Key, doLog: Bool = true) throws -> [T] where T : Decodable {
        var unkeyedContainer = try self.nestedUnkeyedContainer(forKey: key)
        return try unkeyedContainer.decodeArray(type, doLog: doLog)
    }
    
    public func decodeArrayIfPresent<T>(_ type: T.Type, forKey key: Self.Key, doLog: Bool = true) throws -> [T]? where T : Decodable {
        do {
            var unkeyedContainer = try self.nestedUnkeyedContainer(forKey: key)
            return try unkeyedContainer.decodeArray(type, doLog: doLog)
        }
        catch {
            return nil
        }
    }
}
