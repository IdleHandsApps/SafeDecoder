//
//  SafeDecoderLogger.swift
//  SafeDecoder
//
//  Created by Fraser on 16/11/18.
//  Copyright © 2018 IdleHandsApps. All rights reserved.
//

import UIKit

class SafeDecoder: NSObject {
    static var logger: ((_ error: Error, _ typeName: String) -> ())?
}
