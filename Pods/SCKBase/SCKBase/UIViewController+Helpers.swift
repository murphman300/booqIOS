//
//  UIViewController+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit
import CoreLocation

open class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    public func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
            
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    public func decodeJWTPart(_ value: String) throws -> [String: Any] {
        guard let bodyData = base64UrlDecode(value) else {
            throw DecodeError.invalidBase64Url(value)
        }
        print(bodyData)
        guard let json = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableContainers), let payload = json as? [String: Any] else {
            throw DecodeError.invalidJSON(value)
        }
        print(json)
        
        return payload
    }
    
    public enum DecodeError: LocalizedError {
        case invalidBase64Url(String)
        case invalidJSON(String)
        case invalidPartCount(String, Int)
        
        public var localizedDescription: String {
            switch self {
            case .invalidJSON(let value):
                return NSLocalizedString("Malformed jwt token, failed to parse JSON value from base64Url \(value)", comment: "Invalid JSON value inside base64Url")
            case .invalidPartCount(let jwt, let parts):
                return NSLocalizedString("Malformed jwt token \(jwt) has \(parts) parts when it should have 3 parts", comment: "Invalid amount of jwt parts")
            case .invalidBase64Url(let value):
                return NSLocalizedString("Malformed jwt token, failed to decode base64Url value \(value)", comment: "Invalid JWT token base64Url value")
            }
        }
    }
}
