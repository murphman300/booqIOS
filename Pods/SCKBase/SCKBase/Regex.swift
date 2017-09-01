//
//  Regex.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-08-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation


import UIKit

extension NSRegularExpression {
    func count() {
        
    }
}


public enum RegexPatterns : String {
    
    case email = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    case password = "[A-Z0-9a-z.-_!@#$%^&*()+-;:'><?]{6,16}"
    case phoneNumber = "^([0-9]{1,3})([0-9]{0,3})([0-9]{0,4})$"
    case twilioCode = "([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{1})"
    case creditCard = "^([1-9•]{1,4})([0-9•]{1,4})([0-9•]{1,4})([0-9•]{1,4})$"
    case date = "^([1-9]{1,4})([0-9]{0,2})([0-9]{0,2})$"
    init() {
        self = .password
    }
}

public enum RegexTemplate: String {
    
    case twilioReplacementTemplate = "$1 $2 $3 $4 $5 $6 $7"
    case twilioReplacementCompact = "$1$2$3$4$5$6$7"
    case phoneReplacementTemplateSymbolized = "($1) $2 - $3"
    case phoneReplacementTemplatePartSymbolized = "($1) $2"
    case phoneReplacementTemplateSpaced = "$1 $2 $3"
    case phoneReplacementTemplateSingleSpaced = "$1 $2$3"
    case phoneReplacementTemplateCompact = "$1$2$3"
    case passwordTemplate = "$1"
    case creditCardPANCompact = "$1$2$3$4"
    case creditCardPANSpaced = "$1 $2 $3 $4"
    
    public init() {
        self = .twilioReplacementCompact
    }
}

public enum RegexInitError: Error {
    case invalidLength(String)
}


open class Regex {
    open var template = String()
    open var pattern = String()
}

open class PhoneNumber : RegularExpression {
    
    convenience public init(number: String) throws {
        try self.init(value: number, pattern: RegexPatterns.phoneNumber.rawValue, maxlength: nil)
    }
    
    open var compact : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.phoneReplacementTemplateCompact.rawValue)
    }
    open var singleSpaced : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.phoneReplacementTemplateSingleSpaced.rawValue)
    }
    open var spaced : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.phoneReplacementTemplateSpaced.rawValue)
    }
    open var symbolized : String {
        if self.value.characters.count < 4 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.phoneReplacementTemplateCompact.rawValue)
        } else if self.value.characters.count < 7 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.phoneReplacementTemplatePartSymbolized.rawValue)
        } else {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.phoneReplacementTemplateSymbolized.rawValue)
        }
    }
    
}

open class SMSCode : RegularExpression {
    
    convenience public init(entry: String) throws {
        try self.init(value: entry, pattern: RegexPatterns.twilioCode.rawValue, maxlength: nil)
    }
    
    open var compact : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.twilioReplacementCompact.rawValue)
    }
    
    open var spaced : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.twilioReplacementTemplate.rawValue)
    }
    
}

open class Email : RegularExpression {
    
    convenience public init(entry: String) throws {
        try self.init(value: entry, pattern: RegexPatterns.email.rawValue, maxlength: nil)
    }
    
    open var confirm : Bool {
        let match = self.matches(in: value, options: .reportProgress, range: range)
        return match.isEmpty
    }
    
}

open class CreditCardNumber : RegularExpression {
    
    convenience public init(pan: String) throws {
        try self.init(value: pan, pattern: RegexPatterns.creditCard.rawValue, maxlength: nil)
    }
    
    convenience public init(pan: String, maxLength: Int?) throws {
        try self.init(value: pan, pattern: RegexPatterns.creditCard.rawValue, maxlength: maxLength)
    }
    
    open var compactPAN : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.creditCardPANCompact.rawValue)
    }
    
    open var spacedPAN : String {
        let count = range.length
        if 0 < count && count < 5 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.creditCardPANCompact.rawValue)
        } else if 5 <= count && count < 9 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: "$1 $2$3$4")
        } else if 9 <= count && count < 13 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: "$1 $2 $3$4")
        } else if 13 <= count && count <= 16 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: RegexTemplate.creditCardPANSpaced.rawValue)
        } else {
            return ""
        }
    }
    
    open var obfuscated : String {
        let count = range.length
        let obfs = String(withSecureShowOnlyLast4: self.value)
        if 0 < count && count < 5 {
            return self.stringByReplacingMatches(in: obfs, options: .reportProgress, range: range, withTemplate: RegexTemplate.creditCardPANCompact.rawValue)
        } else if 5 <= count && count < 9 {
            return self.stringByReplacingMatches(in: obfs, options: .reportProgress, range: range, withTemplate: "$1 $2$3$4")
        } else if 9 <= count && count < 13 {
            return self.stringByReplacingMatches(in: obfs, options: .reportProgress, range: range, withTemplate: "$1 $2 $3$4")
        } else if 13 <= count && count <= 16 {
            return self.stringByReplacingMatches(in: obfs, options: .reportProgress, range: range, withTemplate: RegexTemplate.creditCardPANSpaced.rawValue)
        } else {
            return ""
        }
    }
    
}


open class RegularExpression: NSRegularExpression {
    
    private var _value = String()
    
    open var value : String {
        get {
            return _value
        } set {
            if let max = maxlength, newValue.characters.count > max {
                print("Attempting to set Value beyond maxLength of : \(max)")
            } else {
                _value = newValue
            }
        }
    }
    
    open var range = NSRange()
    
    open var maxlength : Int?
    
    public init(value: String, pattern: String, maxlength: Int?) throws {
        if let max = maxlength, value.characters.count > max {
            throw RegexInitError.invalidLength("value provided exceeds imposed lenght of \(max)")
        }
        try super.init(pattern: pattern, options: .caseInsensitive)
        self.maxlength = maxlength
        self.value = value
        self.range = NSMakeRange(0, value.characters.count)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
