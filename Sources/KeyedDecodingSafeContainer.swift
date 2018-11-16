//
//  KeyedDecodingErrorContainer.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 1/03/18.
//  Copyright © 2018 IdleHandsApps Ltd. All rights reserved.
//

import UIKit

/// A concrete container that provides a view into an decoder's storage, making
/// the encoded properties of an decodable type accessible by keys.
public struct KeyedDecodingSafeContainer<K> : KeyedDecodingContainerProtocol where K : CodingKey {
    
    var keyedDecodingContainer: KeyedDecodingContainer<K>!
    
    public typealias Key = K
    
    /// Creates a new instance with the given container.
    ///
    /// - parameter container: The container to hold.
    public init<Container>(_ container: Container) where K == Container.Key, Container : KeyedDecodingContainerProtocol {
        self.keyedDecodingContainer = KeyedDecodingContainer(container)
    }
    
    public var errors = [(String, DecodingError)]()
    //public var decodingSafeError: DecodingSafeError?
    
    func getErrors<T>(modelType: T.Type, reference: String? = nil, doLog: Bool = true) -> DecodingSafeError {
        let error = DecodingSafeError.structErrors(type: String(describing: modelType), reference: reference, errors: self.errors)
        if true {
            SafeDecoder.logger?(error, String(describing: T.self))
        }
        return error
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public mutating func decodeSafe<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
        do {
            return try self.keyedDecodingContainer.decode(type, forKey: key)
        }
        catch let error as DecodingError {
            self.errors.append((key.stringValue, error))
            return nil
        }
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public mutating func decodeSafeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
        do {
            return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
        }
        catch let error as DecodingError {
            self.errors.append((key.stringValue, error))
            return nil
        }
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public mutating func decodeArraySafe<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, doLog: Bool = true) throws -> [T]? where T : Decodable {
        do {
            return try self.keyedDecodingContainer.decodeArray(type, forKey: key, doLog: doLog)
            //var unkeyedContainer = try self.nestedUnkeyedContainer(forKey: key)
            //return try unkeyedContainer.decodeArray(type, doLog: doLog)
        }
        catch let error as DecodingError {
            self.errors.append((key.stringValue, error))
            return nil
        }
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public mutating func decodeArraySafeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, doLog: Bool = true) throws -> [T]? where T : Decodable {
        do {
            return try self.keyedDecodingContainer.decodeArrayIfPresent(type, forKey: key, doLog: doLog)
            //var unkeyedContainer = try self.nestedUnkeyedContainer(forKey: key)
            //return try unkeyedContainer.decodeArray(type, doLog: doLog)
        }
        catch let error as DecodingError {
            self.errors.append((key.stringValue, error))
            return nil
        }
    }
    
    
    
    /// The path of coding keys taken to get to this point in decoding.
    public var codingPath: [CodingKey] {
        return self.keyedDecodingContainer.codingPath
    }
    
    /// All the keys the decoder has for this container.
    ///
    /// Different keyed containers from the same decoder may return different keys here, because it is possible to encode with multiple key types which are not convertible to one another. This should report all keys present which are convertible to the requested type.
    public var allKeys: [K] {
        return self.keyedDecodingContainer.allKeys
    }
    
    /// Returns a Boolean value indicating whether the decoder contains a value associated with the given key.
    ///
    /// The value associated with the given key may be a null value as appropriate for the data format.
    ///
    /// - parameter key: The key to search for.
    /// - returns: Whether the `Decoder` has an entry for the given key.
    public func contains(_ key: KeyedDecodingContainer<K>.Key) -> Bool {
        return self.keyedDecodingContainer.contains(key)
    }
    
    /// Decodes a null value for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: Whether the encountered value was null.K
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    public func decodeNil(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        return try self.keyedDecodingContainer.decodeNil(forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Int8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Int16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Int32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Int64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: UInt.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: UInt8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: UInt16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: UInt32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: UInt64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64 {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Float {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Double {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable {
        return try self.keyedDecodingContainer.decode(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Int.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Int8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Int16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Int32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Int64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: UInt.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: UInt8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: UInt16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: UInt32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: UInt64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Float.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Float? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: Double.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Double? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
        return try self.keyedDecodingContainer.decodeIfPresent(type, forKey: key)
    }
    
    /// Returns the data stored for the given key as represented in a container keyed by the given key type.
    ///
    /// - parameter type: The key type to use for the container.
    /// - parameter key: The key that the nested container is associated with.
    /// - returns: A keyed decoding container view into `self`.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is not a keyed container.
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return try self.keyedDecodingContainer.nestedContainer(keyedBy: type, forKey: key)
    }
    
    /// Returns the data stored for the given key as represented in an unkeyed container.
    ///
    /// - parameter key: The key that the nested container is associated with.
    /// - returns: An unkeyed decoding container view into `self`.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is not an unkeyed container.
    public func nestedUnkeyedContainer(forKey key: KeyedDecodingContainer<K>.Key) throws -> UnkeyedDecodingContainer {
        return try self.keyedDecodingContainer.nestedUnkeyedContainer(forKey: key)
    }
    
    /// Returns a `Decoder` instance for decoding `super` from the container associated with the default `super` key.
    ///
    /// Equivalent to calling `superDecoder(forKey:)` with `Key(stringValue: "super", intValue: 0)`.
    ///
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the default `super` key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the default `super` key.
    public func superDecoder() throws -> Decoder {
        return try self.keyedDecodingContainer.superDecoder()
    }
    
    /// Returns a `Decoder` instance for decoding `super` from the container associated with the given key.
    ///
    /// - parameter key: The key to decode `super` for.
    /// - returns: A new `Decoder` to pass to `super.init(from:)`.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func superDecoder(forKey key: KeyedDecodingContainer<K>.Key) throws -> Decoder {
        return try self.keyedDecodingContainer.superDecoder(forKey: key)
    }
    
    /*public func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool?
    
    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int?
    
    public func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8?
    
    public func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16?
    
    public func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32?
    
    public func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64?
    
    public func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt?
    
    public func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8?
    
    public func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16?
    
    public func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32?
    
    public func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64?
    
    public func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float?
    
    public func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double?
    
    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String?
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable*/
}
