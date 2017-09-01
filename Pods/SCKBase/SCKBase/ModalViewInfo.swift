//
//  ModalViewInfo.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public enum ModalViewInfoInitError : Error {
    case missing(String)
}

public class CheckoutModalInfo {
    open var storeName : String
    open var by : String?
    open var amount : Int
    open var recieved = Date()
    open var txid : String
    open var locid : String
    open var logoUrl : String?
    open var path : String? {
        didSet {
            if let p = self.path {
                if !p.contains("http://") && !p.contains("https://") {
                    path = "https://" + p
                }
            }
        }
    }
    open var accessor : String?
    
    public init(from: [String:Any]) throws {
        print(from)
        if let name = from["locname"] as? String {
            storeName = name
        } else {
            throw ModalViewInfoInitError.missing("locname")
        }
        if let name = from["emp_name"] as? String {
            by = name
        }
        if let name = from["amount"] as? Int {
            amount = name
        } else if let name = from["amount"] as? Double {
            amount = Int(name)
        } else if let name = from["amount"] as? String, let value = Int(name){
            amount = value
        } else {
            throw ModalViewInfoInitError.missing("amount")
        }
        if let tx = from["txid"] as? String {
            txid = tx
        } else {
            throw ModalViewInfoInitError.missing("txid")
        }
        if let url = from["logo_url"] as? String {
            logoUrl = url
        }
        if let tx = from["locid"] as? String {
            locid = tx
        } else {
            throw ModalViewInfoInitError.missing("locid")
        }
        if let pa = from["path"] as? String {
            self.path = pa
        }
        if let ac = from["accessor"] as? String {
            self.accessor = ac
        }
        recieved = Date()
    }
}

