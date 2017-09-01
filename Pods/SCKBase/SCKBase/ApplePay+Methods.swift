//
//  ApplePay+Methods.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

import UIKit
import PassKit


public struct ApplePay  {
    
    private static var nets : [PKPaymentNetwork] {
        get {
            if #available(iOS 10.3, *) {
                return [PKPaymentNetwork.amex, PKPaymentNetwork.discover,PKPaymentNetwork.masterCard,PKPaymentNetwork.visa, PKPaymentNetwork.carteBancaire, PKPaymentNetwork.interac, PKPaymentNetwork.privateLabel]
            } else {
                return [PKPaymentNetwork.amex, PKPaymentNetwork.discover,PKPaymentNetwork.masterCard,PKPaymentNetwork.visa, PKPaymentNetwork.interac, PKPaymentNetwork.privateLabel]
            }
        }
    }
    
    public var currentMethods : [PaymentMethod]
    public var unavailableMethods : [PKPaymentNetwork]
    
    public var availableMethods : [PaymentMethod] {
        mutating get {
            return checkApplePayCapabilities()
        }
    }
    
    public mutating func checkApplePayCapabilities() -> [PaymentMethod] {
        currentMethods.removeAll()
        for method in ApplePay.nets {
            do {
                let t = try PaymentMethod(method: method)
                currentMethods.append(t)
            } catch let err as PaymentMethodError {
                if err == .notAvailable {
                    unavailableMethods.append(method)
                } else {
                    
                }
            } catch {
                
            }
        }
        return currentMethods
    }
    
    public struct PaymentMethod {
        
        var type : PKPaymentNetwork
        var string : String
        
        init(method: PKPaymentNetwork) throws {
            if #available(iOS 10, *) {
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [method]) {
                    if #available(iOS 10.3, *) {
                        if method == PKPaymentNetwork.amex {
                            type = method
                            string = "amex"
                        } else if method == PKPaymentNetwork.visa {
                            type = method
                            string = "visa"
                        } else if method == PKPaymentNetwork.masterCard {
                            type = method
                            string = "masterCard"
                        } else if method == PKPaymentNetwork.discover {
                            type = method
                            string = "discover"
                        } else if method == PKPaymentNetwork.carteBancaire {
                            type = method
                            string = "carteBancaire"
                        } else if method == PKPaymentNetwork.chinaUnionPay {
                            type = method
                            string = "chinaUnionPay"
                        } else if method == PKPaymentNetwork.idCredit {
                            type = method
                            string = "idCredit"
                        } else if method == PKPaymentNetwork.JCB {
                            type = method
                            string = "JCB"
                        } else {
                            throw PaymentMethodError.methodNotPresent
                        }
                    } else {
                        if method == PKPaymentNetwork.amex {
                            type = method
                            string = "amex"
                        } else if method == PKPaymentNetwork.visa {
                            type = method
                            string = "visa"
                        } else if method == PKPaymentNetwork.masterCard {
                            type = method
                            string = "masterCard"
                        } else if method == PKPaymentNetwork.discover {
                            type = method
                            string = "discover"
                        } else if method == PKPaymentNetwork.chinaUnionPay {
                            type = method
                            string = "chinaUnionPay"
                        } else {
                            throw PaymentMethodError.methodNotPresent
                        }
                    }
                } else {
                    throw PaymentMethodError.notAvailable
                }
            } else {
                throw PaymentMethodError.minimumOSNotMet
            }
            return
        }
    }
    
    public enum PaymentMethodError : Error {
        case notAvailable
        case methodNotPresent
        case minimumOSNotMet
    }
    
}
