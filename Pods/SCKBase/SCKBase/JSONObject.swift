//
//  JSONObject.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-06-26.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

class JSONObject {
    
    var json : JSON
    
    init(object: [String:Any]) throws {
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            json = JSON(data: data)
        } catch {
            throw JSONObjectParsingError.failed
        }
    }
    
    enum JSONObjectParsingError:  Error {
        case failed
    }
    
}
