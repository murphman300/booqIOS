//
//  MerchantLocation.swift
//  Checkout
//
//  Created by Jean-Louis Murphy on 2017-04-02.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


open class MerchantLocation: NSObject {
    var name: String?
    var locid: String?
    var picurl : String?
    var value : String?
    var attributes : [String]?
    
    public override init() {
        super.init()
    }
    
    init(name: String, locid: String, picurl: String, value: String) {
        self.name = name
        self.locid = locid
        self.picurl = locid
        self.value = value
    }
    convenience init(name: String, locid: String, value: String) {
        self.init()
        self.name = name
        self.locid = locid
        self.value = value
    }
}
