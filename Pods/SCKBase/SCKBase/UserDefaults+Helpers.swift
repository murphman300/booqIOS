//
//  UserDefaults+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    open func make(_ bool: Bool, forKey: String) {
        
        set(bool, forKey: forKey)
        synchronize()
        
    }
    
    //MARK: App Close open funcs
    
    open func openApp(){
        set("hello", forKey: "honey")
        synchronize()
    }
    
    open func getApp() -> String {
        return string(forKey: "honey")!
        
    }
    
    open func appClose() {
        
        removeObject(forKey: "firstname")
        removeObject(forKey: "lastname")
        removeObject(forKey: "sex")
        removeObject(forKey: "age")
        removeObject(forKey: "gender")
        removeObject(forKey: "email")
        removeObject(forKey: "uuid")
        removeObject(forKey: "upid")
        removeObject(forKey: "waid")
        removeObject(forKey: "iss")
        removeObject(forKey: "sub")
        removeObject(forKey: "fbskeyforuser")
        synchronize()
        
    }
    
    //MARK: Login open funcs
    
    open func justInstalled() {
        
        set(false, forKey: "isLoggedIn")
        set(false, forKey: "isConfigured")
        set(false, forKey: "noSafariFromNotifHandler")
        synchronize()
    }
    
    open func dontDoSafariSinceNotifHandler() {
        set(false, forKey: "doSafari")
        set(true, forKey: "noSafariFromNotifHandler")
        synchronize()
    }
    
    open func truth() {
        
        set(false, forKey: "noSafariFromNotifHandler")
        synchronize()
    }
    
    open func setLoggedIn(_ value: Bool) {
        
        self.set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    open func openToSignIn() {
        
        self.set(true, forKey: "isLoggedIn")
        set(true, forKey: "isConfigured")
    }
    
    open func logIn(_ uid: String) {
        self.set(true, forKey: "isLoggedIn")
        self.set(true, forKey: "justLoggedIn")
        set(true, forKey: "isConfigured")
        set(uid, forKey: "fbskeyforuser")
        synchronize()
    }
    
    open func logOut() {
        removeObject(forKey: "omnitoken")
        self.set(false, forKey: "isLoggedIn")
        self.set(false, forKey: "justLoggedIn")
        synchronize()
        
    }
    
    open func setJustLoggedIn() {
        self.set(false, forKey: "justLoggedIn")
        synchronize()
    }
    
    open func isLoggedIn() -> Bool {
        
        return bool(forKey: "isLoggedIn")
        
    }
    
    open func setAutoLog(_ value: Bool) {
        
        self.set(value, forKey: "checkAuto")
        synchronize()
    }
    
    open func doAutoLog() -> Bool{
        
        return bool(forKey: "checkAuto")
        
    }
    
    open func closedApp(_ value: Bool) {
        
        set(value, forKey: "closedApp")
        synchronize()
    }
    
    open func wasAppClosed() -> Bool{
        
        return bool(forKey: "closedApp")
        
    }
    
    open func doSafari(_ value: Bool) {
        
        
        self.set(value, forKey: "shouldSafari")
        synchronize()
    }
    
    open func shouldSafari() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "shouldSafari")
    }
    
    open func shouldSafari(_ completion: @escaping(Bool) -> Void) {
        
        let it = UserDefaults.standard.bool(forKey: "shouldSafari")
        
        completion(it)
    }
    
    
    open func loginVariables() {
        
        
    }
    
    open func saveLogDate(_ type: LoginInfos) {
        let date = NSDate()
        switch  type {
        case .firstLogin:
            UserDefaults.standard.set(date, forKey: "firstLogin")
            synchronize()
        case .lastLogin:
            UserDefaults.standard.set(date, forKey: "lastLogin")
            synchronize()
        case .tokenBirth:
            UserDefaults.standard.set(date, forKey: "omniTokenBirth")
            synchronize()
        }
    }
    
    open func getDate(_ type: LoginInfos) -> NSDate {
        var date = NSDate()
        switch  type {
        case .firstLogin:
            date = UserDefaults.standard.object(forKey: "firstLogin") as! NSDate
        case .lastLogin:
            date = UserDefaults.standard.object(forKey: "lastLogin") as! NSDate
        case .tokenBirth:
            date = UserDefaults.standard.object(forKey: "omniTokenBirth") as! NSDate
        }
        
        return date
    }
    
    open func launchNotif(_ dict: NSDictionary,_ val: Bool) {
        
        
        set(dict, forKey: "apsDictionnary")
        set(val, forKey: "validNotificationPresentFromLaunch")
        synchronize()
    }
    
    open func clearNotif() {
        removeObject(forKey: "apsDictionnary")
        set(false, forKey: "validNotificationPresentFromLaunch")
        synchronize()
        
    }
    
    open func checkNotifFromLaunch() -> Bool {
        return bool(forKey: "validNotificationPresentFromLaunch")
    }
    
    open func getNotifFromLaunch() -> [String: Any] {
        
        let res = object(forKey: "apsDictionnary") as! [String: Any]
        return res
        
    }
    
    //MARK: Token open funcs
    
    open func setToken(_ string: String,_ token: tokenTypes) {
        var val = String()
        
        switch token {
        case .fb:
            val = "fb"
        case .omni:
            val = "omnitoken"
        case .spotit:
            val = "spotit"
        case .device:
            val = "devicetoken"
            
        }
        set(string, forKey: val)
        synchronize()
    }
    
    open func setToken(_ string: String,_ token: tokenTypes, withCompletion: @escaping(Bool) -> Void){
        var val = String()
        
        switch token {
        case .fb:
            val = "fb"
        case .omni:
            val = "omnitoken"
        case .spotit:
            val = "spotit"
        case .device:
            val = "devicetoken"
            
        }
        set(string, forKey: val)
        if synchronize() {
            withCompletion(true)
        } else {
            withCompletion(false)
        }
    }
    
    open func setTokens(_ device: String?,_ omni: String?, fb: String?) {
        
        set(device, forKey: "devicetoken")
        set(omni, forKey: "omnitoken")
        set(fb, forKey: "fb")
        synchronize()
    }
    
    open func clearToken(_ type: tokenTypes) -> Bool {
        
        switch type {
        case .fb:
            removeObject(forKey: "fb")
        case .omni:
            removeObject(forKey: "omnitoken")
        case .spotit:
            removeObject(forKey: "spotit")
        case .device:
            removeObject(forKey: "devicetoken")
            
        }
        
        return synchronize()
    }
    
    open func clearAllTokens() {
        let tokens = ["devicetoken", "omnitoken", "fb"]
        
        for i in 0...(tokens.count - 1) {
            removeObject(forKey: tokens[i])
        }
        synchronize()
    }
    
    open func hasToken(_ type: tokenTypes) -> Bool {
        
        var token = Bool()
        switch type {
        case .fb:
            if string(forKey: "fb") != nil {
                token = true
            } else {
                token = false
                print("\(estrings.userTokError) fb")
            }
        case .omni:
            if string(forKey: "omnitoken") != nil {
                token = true
            } else {
                token = false
                print("\(estrings.userTokError) omni")
            }
        case .spotit:
            if string(forKey: "spotit") != nil {
                token = true
            } else {
                token = false
                print("\(estrings.userTokError) spotit")
            }
            
        case .device:
            if string(forKey: "devicetoken") != nil {
                token = true
            } else {
                print("\(estrings.userTokError) device")
            }
        }
        return token
    }
    
    open func getToken(_ type: tokenTypes) -> String {
        
        var token = String()
        switch type {
        case .fb:
            if string(forKey: "fb") != nil {
                token = string(forKey: "fb")!
            } else {
                token = "\(estrings.userTokError) fb"
            }
        case .omni:
            if string(forKey: "omnitoken") != nil {
                token = string(forKey: "omnitoken")!
            } else {
                token = "\(estrings.userTokError) omniToken"
            }
        case .spotit:
            if string(forKey: "spotit") != nil {
                token = string(forKey: "spotit")!
            } else {
                token = "\(estrings.userTokError) spotit"
            }
        case .device:
            if let b = string(forKey: "devicetoken") {
                token = b
            } else {
                token = "\(estrings.userTokError) device"
            }
        }
        return token
    }
    
    open func getAllTokens() -> Dictionary<String, Any> {
        
        return ["omni":string(forKey: "omnitoken") ?? "nil","device":string(forKey: "devicetoken") ?? "nil"]
    }
    
    open func keyExists(_ key: String) -> Bool {
        var send = false
        if object(forKey: key) != nil {
            send = true
        }
        
        return send
        
    }
    
    open func setTokenValid(_ valid: Bool) {
        
        UserDefaults.standard.make(valid, forKey: "istokenvalid")
        
    }
    
    
    open func isTokenValid(_ token: String?) -> Bool {
        var tok = String()
        var result = Bool()
        
        if token != nil {
            tok = token!
        } else {
            tok = UserDefaults.standard.string(forKey: "omnitoken")!
        }
        
        /*do {
         let po = try decode(jwt: tok)
         
         //let expiry = po.expiresAt
         //print("exoiry at : \(expiry)")
         //print(Date())
         //result = expiry?.compare(Date()) == ComparisonResult.orderedAscending
         
         } catch {
         
         print("was error analysing the token's expiryB")
         }*/
        return result
    }
    
    
    //MARK: User Variables open funcs
    
    
    open func userInfo(_ type: userInfos, value: Any) {
        var makeKey = String()
        switch type {
        case .firstName:
            makeKey = "firstName"
        case .lastName:
            makeKey = "lastName"
        case .age:
            makeKey = "age"
        case .sex:
            makeKey = "gender"
        case .pin:
            makeKey = "pin"
        case .email:
            makeKey = "email"
        case .uuid:
            makeKey = ids.uuid
        case .upid:
            makeKey = ids.upid
        case .sub:
            makeKey = ids.sub
        case .iss:
            makeKey = ids.iss
        case .waid:
            makeKey = ids.waid
        }
        UserDefaults.standard.set(value, forKey: makeKey)
        synchronize()
    }
    open func setAllUser(_ first: String,_ last: String,_ gender: String,_ age: Int,_ email: String,_ syncronizeData: syncronize) {
        
        setValue(first, forKey: "firstname")
        setValue(last, forKey: "lastname")
        setValue(gender, forKey: "gender")
        setValue(age, forKey: "age")
        setValue(email, forKey: "email")
        
        switch syncronizeData {
        case .no:
            break
        case .sync:
            synchronize()
        }
    }
    
    open func getAllUser() -> Dictionary<String, Any> {
        
        return ["first":string(forKey: "firstname") ?? "Jean-Louis", "last":string(forKey: "lastname") ?? "Murphy", "sex":string(forKey: "sex") ?? "", "age":string(forKey: "age") ?? "25", "email":string(forKey: "email") ?? "jeanlouismurphy@gmail.com", "upid": string(forKey: "upid") as Any]
        
        
    }
    
    open func setAllIds(_ uuid: String,_ waid: String?,_ upid: String,_ sub: String,_ iss: Int,_ uid: String,_ syncronizeData: syncronize) {
        
        setValue(uuid, forKey: "uuid")
        setValue(waid, forKey: "waid")
        setValue(upid, forKey: "upid")
        setValue(sub, forKey: "sub")
        setValue(iss, forKey: "iss")
        set(uid, forKey: "fbskeyforuser")
        
        switch syncronizeData {
        case .no:
            break
        case .sync:
            synchronize()
        }
        
    }
    
    open func getUserInfo(_ type: userInfos) -> String {
        var makeKey = String()
        var result = String()
        switch type {
        case .firstName:
            makeKey = "firstName"
            result = string(forKey: makeKey)!
        case .lastName:
            makeKey = "lastName"
            result = string(forKey: makeKey)!
        case .age:
            makeKey = "age"
            result = string(forKey: makeKey)!
        case .sex:
            makeKey = "sex"
            result = string(forKey: makeKey)!
        case .pin:
            makeKey = "pin"
            result = string(forKey: makeKey)!
        case .email:
            makeKey = "email"
            result = string(forKey: makeKey)!
        case .uuid:
            makeKey = ids.uuid
            result = string(forKey: makeKey)!
        case .upid:
            makeKey = ids.upid
            result = string(forKey: makeKey)!
        case .sub:
            makeKey = ids.sub
            result = string(forKey: makeKey)!
        case .iss:
            makeKey = ids.iss
            result = String(describing: integer(forKey: makeKey))
        case .waid:
            makeKey = ids.waid
            result = string(forKey: makeKey)!
        }
        return result
    }
    
    open func saveUserInfo(_ firstName: String?, _ lastName: String?, _ sex: String?, _ age: String?, _ pin: String?, _ email: String?) {
        
        if firstName != nil {
            userInfo(.firstName, value: firstName!)
        }
        if lastName != nil {
            userInfo(.lastName, value: lastName!)
        }
        if sex != nil {
            userInfo(.sex, value: sex!)
        }
        if age != nil {
            userInfo(.age, value: age!)
        }
        if pin != nil {
            userInfo(.pin, value: pin!)
        }
        if email != nil {
            userInfo(.email, value: email!)
        }
    }
    
    open func saveUserIDs(_ iss: Int?, _ uuid: String?, _ upid: String?, _ sub: String?) {
        
        if iss != nil {
            userInfo(.iss, value: iss!)
        }
        if uuid != nil {
            userInfo(.uuid, value: uuid!)
        }
        if upid != nil {
            userInfo(.upid, value: upid!)
        }
        if sub != nil {
            userInfo(.sub, value: sub!)
        }
    }
    
    open func getUserID() -> [String : Any] {
        
        var result = [String : Any]()
        
        result = ["iss" : integer(forKey: "iss"), "uuid" : getUserInfo(.uuid), "upid" : getUserInfo(.upid), "sub" : getUserInfo(.sub)]
        
        return result
        
    }
    
    open func setMethods(_ legacy: Bool,_ bitcoin: Bool,_ operatingSystem: Bool,_ ripple: Bool,_ giftCards: Bool) {
        
        set(legacy, forKey: "legacyMethodKey")
        set(bitcoin, forKey: "bitcoinMethodKey")
        set(operatingSystem, forKey: "operatingSystemMethodKey")
        set(ripple, forKey: "rippleMethodKey")
        set(giftCards, forKey: "giftCardsMethodKey")
        synchronize()
        returnMethodsKeyString()
    }
    
    open func returnMethodsKeyString() -> String {
        
        var string = String()
        
        let parseobj = ["leg":UserDefaults.standard.bool(forKey: "legacyMethodKey"), "btc":UserDefaults.standard.bool(forKey: "bitcoinMethodKey"), "ops":UserDefaults.standard.bool(forKey: "operatingSystemMethodKey"), "rpl": UserDefaults.standard.bool(forKey: "rippleMethodKey"), "gfc":UserDefaults.standard.bool(forKey: "giftCardsMethodKey")] as [String:Bool]
        
        for value in parseobj {
            
            if value.value {
                string += "\(value.key)&"
            }
        }
        
        if string.characters.count != 0 {
            
            string.chopSuffix(1)
            
        } else {
            string = "applepay"
        }
        return string
    }
    
    //MARK: encryption open funcs
    
    /*open func setEncryptKeys(_ now: Date) -> Bool {
     let number = UInt64.random(lower: 1, upper: 34)
     let number2 = Int(UInt64.random(lower: 1, upper: 5)) * (-1)
     let firstdate = Calendar.current.date(byAdding: .day, value: Int(number), to: now, wrappingComponents: false)
     let seconddate = Calendar.current.date(byAdding: .day, value: Int(number2), to: now, wrappingComponents: false)
     setValue(now, forKey: "firstlogin2974986652")
     setValue(firstdate, forKey: "firstlogin8328692")
     setValue(seconddate, forKey: "firstlogin48782389")
     print("SETTING ENCRYPTION KEYS")
     var zipo = Bool()
     let zip = UserDefaults.standard.keyExists("whatHasLoginDo")
     if zip == true {
     zipo = UserDefaults.standard.bool(forKey: "whatHasLoginDo")
     } else {
     UserDefaults.standard.set(true, forKey: "whatHasLoginDo")
     zipo = true
     }
     if UserDefaults.standard.bool(forKey: "newTokenEstablished") {
     UserDefaults.standard.set(!zipo, forKey: "whatHasLoginDo")
     zipo = !zipo
     }
     synchronize()
     
     
     
     return zipo
     }*/
    
    open func setEncryptKeys(_ now: Date, withCompletion: @escaping(Bool) -> Void) {
        let number = UInt64.random(lower: 1, upper: 34)
        let number2 = Int(UInt64.random(lower: 1, upper: 5)) * (-1)
        let firstdate = Calendar.current.date(byAdding: .day, value: Int(number), to: now, wrappingComponents: false)
        let seconddate = Calendar.current.date(byAdding: .day, value: Int(number2), to: now, wrappingComponents: false)
        setValue(now, forKey: "firstlogin2974986652")
        setValue(firstdate, forKey: "firstlogin8328692")
        setValue(seconddate, forKey: "firstlogin48782389")
        print("SETTING ENCRYPTION KEYS")
        var zipo = Bool()
        let zip = UserDefaults.standard.keyExists("whatHasLoginDo")
        if zip == true {
            zipo = UserDefaults.standard.bool(forKey: "whatHasLoginDo")
        } else {
            UserDefaults.standard.set(true, forKey: "whatHasLoginDo")
            zipo = true
        }
        if UserDefaults.standard.bool(forKey: "newTokenEstablished") {
            UserDefaults.standard.set(!zipo, forKey: "whatHasLoginDo")
            zipo = !zipo
        }
        
        guard synchronize() else {
            withCompletion(false)
            return
        }
        withCompletion(zipo)
    }
    
    open func setDecryptKeys() -> [String:Any] {
        
        let initial = UserDefaults.standard.bool(forKey: "whatHasLoginDo")
        guard let valid = UserDefaults.standard.value(forKey: "firstlogin2974986652") as? Date else {
            return [:]
        }
        
        synchronize()
        return ["do": initial, "date": valid]
    }
    
    //MARK: Location Label
    
    open func setCity(_ locality: String,_ adminArea: String) {
        
        set("\(locality), \(adminArea)", forKey: "locationcityandarea")
        synchronize()
    }
    
    open func getCity() -> String? {
        
        if let res = string(forKey: "locationcityandarea") {
            return res
        }
        
        return nil
    }
}
