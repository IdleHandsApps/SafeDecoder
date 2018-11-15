//
//  Planet.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 8/12/18.
//  Copyright © 2018 IdleHandsApps. All rights reserved.
//

import Foundation

struct Planet {
    var name: String = ""
    var diameter: Double
    var daysForRotation: Double
    var isHabitable: Bool
}

// MARK: Planet Codable
extension Planet: Codable {
    
    // MARK: Planet CodingKeys
    internal enum CodingKeys: String, CodingKey {
        case name = "name"
        case diameter = "diameter"
        case daysForRotation = "daysForRotation"
        case isHabitable = "isHabitable"
    }
    
    // MARK: Planet Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(diameter, forKey: .diameter)
        try container.encode(daysForRotation, forKey: .daysForRotation)
        try container.encode(isHabitable, forKey: .isHabitable)
    }
    
    // MARK: Planet Decodable
    init(from decoder: Decoder) throws {
        
        // to gather all decoding errors implement safeContainer() rather than the usual container()
        var container = try decoder.safeContainer(keyedBy: CodingKeys.self)
        
        let _name = (try container.decodeSafe(String.self, forKey: .name))
        let _diameter = (try container.decodeSafe(Double.self, forKey: .diameter))
        let _daysForRotation = (try container.decodeSafe(Double.self, forKey: .daysForRotation))
        let _isHabitable = (try container.decodeSafe(Bool.self, forKey: .isHabitable))
        
        guard
            let name = _name,
            let diameter = _diameter,
            let daysForRotation = _daysForRotation,
            let isHabitable = _isHabitable
            else {
                // the reference can be your object identifier to help find the issue in your data
                throw container.getErrors(modelType: Planet.self, reference: _name)
        }
        self.name = name
        self.diameter = diameter
        self.daysForRotation = daysForRotation
        self.isHabitable = isHabitable
    }
}
