//
//  LocationAddress.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-04-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public struct LocationAddress {
    
    let country : String
    let municipality : String
    let number : String
    let postalCode : String
    let state : String
    let street : String
    
    
    
    public init(country: String, municipality: String, number: String,  postalCode: String,  state: String,  street: String) {
        
        self.country = country
        self.municipality = municipality
        self.number = municipality
        self.postalCode = postalCode
        self.state = state
        self.street = street
    }
}
