//
//  LocalData.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-01-17.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

open class LocalData {
    open var isAssigned : Bool = false
    open var street = String()
    open var number = String()
    open var municipality = String()
    open var unit = String()
    open var state = State()
    open var country = Country()
    open var postalcode = PostalCode()
    
    open var fullAddress : String {
        get {
            guard unit.isEmpty else {
                
                return "\(number) \(street), #\(unit), \(municipality), \(state), \(country), \(postalcode)"
            }
            
            return "\(number) \(street), \(municipality), \(state), \(country), \(postalcode)"
        }
    }
    open var canBeObject: Bool {
        get {
            guard isAssigned else {
                return false
            }
            return true
        }
    }
    
    private var hasUnit: Bool {
        get {
            return unit.isEmpty
        }
    }
    
    open var streetAddress: String {
        get {
            return "\(number) \(street)"
        }
    }
    
    open var dict : [String:Any] {
        get {
            guard canBeObject else {
                return [:]
            }
            guard hasUnit else {
                return ["street": street, "number": number, "municipality": municipality, "state": state, "country": country, "postalcode": postalcode]
            }
            return ["street": street, "number": number, "municipality": municipality, "unit": unit, "state": state, "country": country, "postalcode": postalcode]
        }
    }
    
    open var dataObject : Data? {
        get {
            let obj = dict
            do {
                guard dict.isEmpty else {
                    let data = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    return data
                }
                return nil
            } catch {
                return nil
            }
        }
    }
}
