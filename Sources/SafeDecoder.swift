//
//  SafeDecoder.swift
//  IdleHandsApps
//
//  Created by Fraser Scott-Morrison on 16/11/18.
//  Copyright © 2018 IdleHandsApps. All rights reserved.
//

import UIKit

public class SafeDecoder: NSObject {
    public static var logger: ((_ error: Error, _ typeName: String) -> ())?
}
