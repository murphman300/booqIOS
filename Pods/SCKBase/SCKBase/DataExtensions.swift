//
//  DataExtensions.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-04-09.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

extension NSMutableData {
    public func appendString(string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return
        }
        append(data)
    }
}
