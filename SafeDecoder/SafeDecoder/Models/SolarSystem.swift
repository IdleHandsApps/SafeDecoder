//
//  SolarSystem.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 8/12/18.
//  Copyright © 2018 IdleHandsApps. All rights reserved.
//

import Foundation

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
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        // to parse an array without re-thowing an error, call decodeArray()
        planets = try container.decodeArray(Planet.self, forKey: .planets)
    }
}
