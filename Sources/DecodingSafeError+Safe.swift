//
//  DecodingSafeError+Safe.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 1/03/18.
//  Copyright © 2018 IdleHandsApps Ltd. All rights reserved.
//

import UIKit

extension DecodingSafeError: CustomStringConvertible {
    
    public var description: String {
        return multiline(verbosity: .multiple).joined(separator: "\n")
    }
    
    public var fullDescription: String {
        return multiline(verbosity: .full).joined(separator: "\n")
    }
    
    private enum Verbosity {
        case full
        case multiple
        case single
        
        func to(_ other: Verbosity) -> Verbosity {
            if case .full = self { return .full }
            return other
        }
    }
    
    private func multiline(verbosity: Verbosity) -> [String] {
        switch self {
        case .arrayElementErrors(let errors):
            let errs = errors.map { (ix, err) in ("[\(ix)]", err) }
            return DecodingSafeError.lines(verbosity: verbosity, type: "array", reference: nil, errors: errs)
            
        case .dictionaryErrors(let errors):
            let errs = errors.map { (key, err) in ("\(key):", err) }
            return DecodingSafeError.lines(verbosity: verbosity, type: "dictionary", reference: nil, errors: errs)
            
        case .structErrors(let type, let reference, let errors):
            let errs = errors.map { (key, err) in ("\(key):", err) }
            return DecodingSafeError.lines(verbosity: verbosity, type: "\(type) struct", reference: reference, errors: errs)
        }
    }
    
    private var line: String {
        switch self {
        case let .arrayElementErrors(errors):
            return errors.count == 1
                ? "(1 error in an array element)"
                : "(\(errors.count) errors in array elements)"
            
        case let .dictionaryErrors(errors):
            return errors.count == 1
                ? "(1 error in dictionary)"
                : "(\(errors.count) errors in dictionary)"
            
        case let .structErrors(type, reference, errors):
            var errorLine = errors.count == 1
                ? "(1 error in nested \(type) struct)"
                : "(\(errors.count) errors in nested \(type) struct)"
            if reference != nil {
                errorLine += " with reference \(reference!)"
            }
            return errorLine
        }
    }
    
    private func listItem(collapsed: Bool) -> String {
        switch self {
        case .arrayElementErrors, .dictionaryErrors, .structErrors:
            return collapsed ? "▹" : "▿"
        }
    }
    
    private static func lines(verbosity: Verbosity, type: String, reference: String?, errors: [(String, DecodingError)]) -> [String] {
        if errors.count == 0 { return [] }
        
        func prefix(_ prefix: String, lines: [String]) -> [String] {
            if let first = lines.first {
                let fst = ["\(prefix)\(first)"]
                let rst = lines.suffix(from: 1).map { "   \($0)" }
                return fst + rst
            }
            
            return []
        }
        
        var result: [String] = []
        let multiple = errors.count > 1
        
        var head = multiple
            ? "\(errors.count) errors in \(type)"
            : "1 error in \(type)"
        if reference != nil {
            head += " with ref: \(reference!)"
        }
        result.append(head)
        
        for (key, error) in errors {
            
            var errorName = "unknown"
            switch error {
            case .typeMismatch:
                errorName = "typeMismatch"
            case .valueNotFound:
                errorName = "valueNotFound"
            case .keyNotFound:
                errorName = "keyNotFound"
            case .dataCorrupted:
                errorName = "dataCorrupted"
            }
            
            //if multiple && verbosity == .single {
                result.append(" \(error.errorDescription ?? "") \(key) \(errorName)")
                //result.append(" \(error.listItem(collapsed: true)) \(key) \(error.line)")
            //}
            //else {
                //let lines = error.multiline(verbosity: verbosity.to(.single))
                //result = result + prefix(" \(error.listItem(collapsed: false)) \(key) ", lines: lines)
            //}
        }
        
        return result
    }
}
