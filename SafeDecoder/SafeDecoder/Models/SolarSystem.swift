//
//  SolarSystem.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 8/12/18.
//  Copyright © 2018 IdleHandsApps. All rights reserved.
//

import Foundation
import UIKit

struct SolarSystem {
    var name: String = ""
    var planets = [Planet]()
}

// MARK: SolarSystem Codable
extension SolarSystem: Codable {
    
    // MARK: SolarSystem CodingKeys
    internal enum CodingKeys: String, CodingKey {
        case name = "name"
        case planets = "planets"
    }
    
    // MARK: SolarSystem Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(planets, forKey: .planets)
    }
    
    // MARK: SolarSystem Decodable
    public init(from decoder: Decoder) throws {
        
        var container = try decoder.safeContainer(keyedBy: CodingKeys.self)
        
        let _name = try container.decodeSafe(String.self, forKey: .name)
        let _planets = try container.decodeArraySafe(Planet.self, forKey: .planets)
        
        guard
            let name = _name,
            let planets = _planets
            else {
                // the reference can be your object identifier to help find the issue with your data
                throw container.getErrors(modelType: type(of: self), reference: _name)
        }
        
        self.name = name
        self.planets = planets
    }
}


struct MyModelXX: Decodable {
    
    var myArray: [CGRect]
    
    enum CodingKeys: String, CodingKey {
        case myArray
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // to parse an array without re-thowing an error, call decodeArray()
        myArray = try container.decodeArray(CGRect.self, forKey: .myArray)
    }
}
