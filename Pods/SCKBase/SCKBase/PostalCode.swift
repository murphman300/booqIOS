//
//  PostalCode.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

open class PostalCode {

    private var suff : String?
    private var pref : String?
    
    open var code : String? {
        get {
            guard let su = suff, let pr = pref else {
                return nil
            }
            return "\(su)-\(pr)"
        } set {
            guard let p = newValue else {
                return
            }
            guard p.contains("-") else {
                var n = p
                suff = String()
                pref = String()
                while (suff?.characters.count)! < n.characters.count {
                    if let ne = n.characters.popFirst() {
                        suff?.append(ne)
                    }
                }
                while n.characters.count != 0 {
                    if let ne = n.characters.popFirst() {
                        pref?.append(ne)
                    }
                }
                return
            }
            let co = p.components(separatedBy: "-")
            guard co.count == 2 else {
                return
            }
            suff = String()
            pref = String()
            suff = co[0]
            pref = co[1]
        }
    }
    
    open var compact : String? {
        get {
            guard let su = suff else {
                return nil
            }
            guard let pr = pref else {
                return nil
            }
            return "\(su)\(pr)"
        }
    }
    
    open var isCode : Bool {
        get {
            guard let c = compact else {
                return false
            }
            return c.isPostalCode()
        }
    }
    
    
    public init(){
        
    }
    
    
}
