//
//  String+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

extension String: ExpressibleByArrayLiteral {
    public typealias Element = Swift.Int
    
    //public typealias OtherElement = Character
    
    public init(arrayLiteral elements: Swift.Int...) {
        self.init()
        self = "\(elements.reduce(0,+))"
    }
    
    public init(withSecureShowOnlyLast4 values : String) {
        self.init()
        let array = [Character](values.characters)
        if array.count <= 4 {
            self = values
        } else {
            var first = array.count - 4
            var lastFour : [Character] = []
            while first <= (array.count - 1) {
                lastFour.append(array[first])
                first += 1
            }
            self = String(Array(repeating: "•", count: array.count - 4) + lastFour)
        }
    }
    
}



extension String {
    
    var charValues : [Character] {
        get {
            guard self.isEmpty else {
                return [Character](self.characters)
            }
            return []
        }
    }
    
    public func toDate() -> Date? {
        
        let date = NSDate(dateString: self)
        return date as Date
        
    }
    
    public func dateIsValid() -> Bool {
        let date = toDate()
        guard date != nil else {
            return false
        }
        return date!.hasPast()
    }
    
    public func hasDigits() -> Bool {
        let k = keyboard.digits
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        return v
    }
    
    public func hasSymbol() -> Bool {
        let k = keyboard.symbols
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        return v
    }
    
    public func isSymbol() -> Bool {
        let k = keyboard.symbols
        let a = keyboard.all
        var v = false
        for val in self.characters {
            for letter in k.characters {
                if letter == val {
                    v = true
                    break
                }
            }
        }
        if !v {
            var other : Bool = false
            for val in self.characters {
                for letter in a.characters {
                    if letter == val {
                        other = true
                        break
                    }
                }
            }
            if !other {
                v = true
            }
        }
        return v
    }
    
    public func hasDigits(_ comp: @escaping (Bool) -> Void) {
        let k = keyboard.digits
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        comp(v)
    }
    
    public func hasLowerCase() -> Bool {
        let k = keyboard.lowercase
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        return v
    }
    
    public func hasUpperCase() -> Bool {
        let k = keyboard.uppercase
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        return v
    }
    public func hasSpecialChar() -> Bool {
        let k = keyboard.symbols
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        return v
    }
    
    public func hasSpecialChar(_ comp: @escaping (Bool) -> Void) {
        let k = keyboard.symbols
        var v = false
        for letter in self.characters {
            if k.contains("\(letter)") {
                v = true
                break
            }
        }
        comp(v)
    }
    
    public func isOnlyUpperAndLowerCase() -> Bool {
        let k = keyboard.uppercase
        let o = keyboard.lowercase
        var yes = true
        for letter in self.characters {
            var v = false
            if k.contains("\(letter)"){
                v = true
            }
            v = false
            if o.contains("\(letter)"){
                v = true
            }
            if !v {
                yes = v
                break
            }
        }
        return yes
    }
    
    public func isOnlyUpperAndLowerCase(_ comp: @escaping (Bool) -> Void){
        let k = keyboard.uppercase
        let o = keyboard.lowercase
        var yes = true
        for letter in self.characters {
            var v = false
            if k.contains("\(letter)"){
                v = true
            }
            if o.contains("\(letter)"){
                v = true
            }
            if !v {
                yes = v
                break
            }
        }
        comp(yes)
    }
    
    public func isPostalCode(_ comp: @escaping (Bool) -> Void){
        let k = keyboard.uppercase
        let o = keyboard.digits
        var yes = true
        for letter in self.characters {
            var v = false
            if k.contains("\(letter)"){
                v = true
            }
            if o.contains("\(letter)"){
                v = true
            }
            if !v {
                yes = v
                break
            }
        }
        
        comp(yes)
    }
    
    public func isPostalCode() -> Bool {
        let k = keyboard.uppercase
        let o = keyboard.digits
        var yes = true
        for letter in self.characters {
            var v = false
            if k.contains("\(letter)"){
                v = true
            }
            if o.contains("\(letter)"){
                v = true
            }
            if !v {
                yes = v
                break
            }
        }
        
        return yes
    }
    
    public func isOnlyDigits() -> Bool{
        let k = keyboard.digits
        var yes = true
        for letter in self.characters {
            if !k.contains("\(letter)"){
                yes = false
                break
            }
        }
        return yes
    }
    
    public func isOnlyDigits(_ comp: @escaping (Bool) -> Void){
        let k = keyboard.digits
        var yes = true
        for letter in self.characters {
            if !k.contains("\(letter)"){
                yes = false
                break
            }
        }
        comp(yes)
    }
    
    
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    public func toDecimalNumber() -> NSDecimalNumber {
        
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: (self as NSString) as String) as? NSDecimalNumber ?? 0
        
    }
    
    public func keepString(asOf: Character) -> String {
        
        let c = self.characters
        var final = String()
        if let mark = c.index(of: asOf) {
            
            final = self[c.index(after: mark)..<self.endIndex]
            
        }
        return final
    }
    
    public func base64Encoded() -> String {
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    public func base64Decoded() -> String {
        let decodedData = NSData(base64Encoded: self, options:NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)
        return decodedString! as String
    }
    
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    public func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    
    public func dateFromString() -> Date {
        var timeStamp = String()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
        var localTimeZoneName: String { return (NSTimeZone.local as NSTimeZone).name }
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return dateFormatter.date(from: self)!// create date from string
    }
    
    public func toLocalTimeLabelForCell() -> String {
        
        var timeStamp = String()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
        var localTimeZoneName: String { return (NSTimeZone.local as NSTimeZone).name }
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: self) // create date from string
        
        let interdate = date?.timeIntervalSinceNow
        
        let intSecs = Int(interdate!)
        let intermins = intSecs / 60
        _ = intermins / 60
        let intdays = ((interdate! / 60) / 60) / 24
        _ = intdays / 7
        _ = intdays / 30
        
        let minute = Calendar.current.component(.minute, from: date!)
        let hour = Calendar.current.component(.hour, from: date!)
        let day = Calendar.current.component(.day, from: date!)
        let month = Calendar.current.component(.month, from: date!)
        let year = Calendar.current.component(.year, from: date!)
        
        let nMinute = Calendar.current.component(.minute, from: NSDate() as Date)
        let nHour = Calendar.current.component(.hour, from: NSDate() as Date)
        let nDay = Calendar.current.component(.day, from: NSDate() as Date)
        let nMonth = Calendar.current.component(.month, from: NSDate() as Date)
        let nYear = Calendar.current.component(.year, from: NSDate() as Date)
        
        let dif = (nDay - day)
        
        
        
        //make it general
        guard year != nYear || month != nMonth && dif > 7 else {
            
            guard (nDay - day) == 7 else {
                
                guard dif > 1 else {
                    
                    guard dif == 1 else {
                        
                        guard (nHour - hour) != 0 else {
                            guard (nMinute - minute) != 0 else {
                                return "Just Now"
                            }
                            return "\(minute) Minutes Ago"
                        }
                        
                        if nHour > 0 && nHour <= 12 {
                            guard hour > 12 else {
                                return "\(hour):\(minute) AM"
                            }
                            return "Yesterday"
                            
                        } else if nHour > 12 && nHour <= 17{
                            guard hour < 12 else {
                                
                                return "\(hour):\(minute) PM"
                            }
                            return "This Morning"
                        } else if nHour >= 18 {
                            
                            guard (nHour - hour) > 3 else {
                                
                                return "\(hour):\(minute) PM"
                            }
                            
                            guard hour > 12 else {
                                
                                return "This Morning"
                            }
                            
                            guard hour > 18 else {
                                
                                return "This Afternoon"
                            }
                        }
                        return "Yesterday"
                    }
                    
                    return "Yesterday"
                }
                
                return "\(dif) days ago"
            }
            
            return "A Week Ago"
        }
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "EEE, MMM d, yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    public func chopSuffix(_ byPositiveCount: Int) -> String {
        return self.substring(to: self.characters.index(self.endIndex, offsetBy: -byPositiveCount))
    }
    public func chopPrefix(_ count: Int) -> String {
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: count))
    }
    
    public func checkIfValidWaid() -> Bool {
        
        let count = self.characters.count - 1
        var new = self.chopSuffix(count - 4)
        guard new.characters.count == 5 else {
            print("Fatal Error: checking validWaid returned a string different then 5")
            return false
        }
        guard new.characters.popFirst() == "w" else {
            print("Fatal Error: the submitted waid string is invalid or not a waid - W was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "a" else {
            print("Fatal Error: the submitted waid string is invalid or not a waid - A was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "i" else {
            print("Fatal Error: the submitted waid string is invalid or not a waid - I was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "d" else {
            print("Fatal Error: the submitted waid string is invalid or not a waid - D was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "_" else {
            print("Fatal Error: the submitted waid string is invalid or not a waid - _ was not present in the string")
            return false
        }
        
        return true
    }
    
    public func checkIfValidPrid() -> Bool {
        
        let count = self.characters.count - 1
        var new = self.chopSuffix(count - 4)
        guard new.characters.count == 5 else {
            print("Fatal Error: checking validPrid for /prid_/ returned a string different then 5")
            return false
        }
        guard new.characters.popFirst() == "p" else {
            print("Fatal Error: the submitted prid string is invalid or not a waid - P was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "r" else {
            print("Fatal Error: the submitted prid string is invalid or not a waid - R was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "i" else {
            print("Fatal Error: the submitted prid string is invalid or not a waid - I was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "d" else {
            print("Fatal Error: the submitted prid string is invalid or not a waid - D was not present in the string")
            return false
        }
        guard new.characters.popFirst() == "_" else {
            print("Fatal Error: the submitted prid string is invalid or not a waid - _ was not present in the string")
            return false
        }
        
        return true
    }
    
    public func zipped(_ with: String) -> String {
        var zipped = String()
        
        _ = UInt32(arc4random_uniform(3))
        
        var char = characters
        var char2 = randomString(length: char.count).characters
        
        var up : Bool = true
        
        while char2.count != 0 {
            if up {
                if char.count > 0 {
                    zipped.append(char.popFirst()!)
                }
                up = false
            } else {
                zipped.append(char2.popFirst()!)
                up = true
            }
        }
        
        return zipped
    }
    
    public func zipped() -> String {
        var zipped = String()
        var char = characters
        var char2 = randomString(length: char.count).characters
        var up : Bool = true
        while char2.count != 0 {
            if up {
                if char.count > 0 {
                    zipped.append(char.popFirst()!)
                }
                up = false
            } else {
                zipped.append(char2.popFirst()!)
                up = true
            }
        }
        return zipped
    }
    
    public func unzipped() -> String {
        var stri = self
        var result = String()
        var char2 = String()
        
        var up : Bool = true
        
        while stri.characters.count >= 1 {
            if up {
                result.append(stri.characters.popFirst()!)
                up = false
            } else {
                char2.append(stri.characters.popFirst()!)
                up = true
            }
        }
        
        return result
    }
    
    
    public func zip(_ with: String) -> String {
        var zipped = String()
        
        var char = characters
        var char2 = with.characters
        var up : Bool = true
        while char2.count != 0 {
            if up {
                if char.count > 0 {
                    zipped.append(char.popFirst()!)
                }
                up = false
            } else {
                zipped.append(char2.popFirst()!)
                up = true
            }
        }
        zipped.append("@4OJKO")
        
        return zipped
    }
    
    public func apiZip(_ with: String) -> String {
        var zipped = String()
        
        var char = characters
        var char2 = with.characters
        var up : Bool = true
        while char2.count != 0 {
            if up {
                if char.count > 0 {
                    zipped.append(char.popFirst()!)
                }
                up = false
            } else {
                zipped.append(char2.popFirst()!)
                up = true
            }
        }
        
        return zipped
    }
    
    public func skipZip(_ with: String) -> String {
        var zipped = String()
        
        _ = UInt32(arc4random_uniform(3))
        
        var char = characters
        var char2 = with.characters
        
        var up : Bool = true
        
        while char2.count != 0 {
            if up {
                if char.count > 0 {
                    zipped.append(char.popLast()!)
                }
                up = false
            } else {
                zipped.append(char2.popFirst()!)
                up = true
            }
        }
        zipped.append("@NU89Q")
        
        return zipped
    }
    
    public func unZippedPair() -> ZippedPair {
        var stri = self
        let res = ZippedPair()
        
        var up : Bool = true
        
        while stri.characters.count >= 1 {
            if up {
                res.other.append(stri.characters.popFirst()!)
                up = false
            } else {
                res.main.append(stri.characters.popFirst()!)
                up = true
            }
        }
        
        return res
    }
    
    open class ZippedPair {
        
        var main = String()
        var other = String()
    }
    
    public func skipZipAlt(_ with: String) -> String {
        
        var zipped = String()
        
        _ = UInt32(arc4random_uniform(2))
        
        var char = characters
        var char2 = with.characters
        
        var up : Bool = true
        
        while char2.count != 0 {
            if up {
                if char.count > 0 {
                    zipped.append(char.popLast()!)
                }
                up = false
            } else {
                zipped.append(char2.popFirst()!)
                up = true
            }
        }
        zipped.append("@k?*q#")
        
        return zipped
    }
    
    public func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%^&*()><?.,.~"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    public func eightBitRandom() -> String {
        return randomString(length: 8)
    }
    public func sixteenBitRandom() -> String {
        return randomString(length: 16)
    }
    public func twentyFourBitRandom() -> String {
        return randomString(length: 24)
    }
    public func thirtyTwoBitRandom() -> String {
        return randomString(length: 32)
    }
    public func sixtyFourBitRandom() -> String {
        return randomString(length: 64)
    }
}

