//
//  KeyedDecodingErrorContainer.swift
//  Neighbourly
//
//  Created by Fraser on 1/03/18.
//  Copyright © 2018 Neighbourly Ltd. All rights reserved.
//

import UIKit

extension Decoder {
    /// Returns the data stored in this decoder as represented in a container keyed by the given key type.
    ///
    /// - parameter type: The key type to use for the container.
    /// - returns: A keyed decoding container view into this decoder.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is not a keyed container.
    public func safeContainer<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingSafeContainer<Key> where Key : CodingKey {
        let container = try self.container(keyedBy: type)
        return KeyedDecodingSafeContainer(container)
    }
}

/// An error that occurs during the decoding of a value.
public enum DecodingSafeError : Error {
    case arrayElementErrors([(Int, DecodingError)])
    case dictionaryErrors([(String, DecodingError)])
    case structErrors(type: String, reference: String?, errors: [(String, DecodingError)])
}
