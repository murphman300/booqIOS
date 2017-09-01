//
//  AppLicense.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-09-01.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

enum AppLicense : Int {
    
    case FirebaseCore = 0
    case FirebaseAuth = 1
    case FirebaseDatabase = 2
    case FirebaseStorage = 3
    case GTM = 4
    case leveldbLibrary = 5
    case SCKBase = 6
    
    var title : String {
        switch self {
        case .FirebaseCore:
            return "Firebase Core"
        case .leveldbLibrary:
            return "leveldb-library"
        case .FirebaseDatabase:
            return "Firebase Database"
        case .FirebaseStorage:
            return "Firebase Storage"
        case .FirebaseAuth:
            return "Firebase Auth"
        case .GTM:
            return "GTM"
        case .SCKBase:
            return "SCKBase"
        }
    }
    
    var content : String {
        let bundle = Bundle.main
        switch self {
        case .FirebaseCore, .FirebaseAuth, .FirebaseStorage, .FirebaseDatabase:
            guard let path = bundle.path(forResource: "GoogleLicenseFile", ofType: "txt") else {
                return ""
            }
            do {
                let content = try String.init(contentsOfFile: path)
                return content
            } catch {
                return ""
            }
        case .GTM:
            guard let path = bundle.path(forResource: "GTMLicense", ofType: "txt") else {
                return ""
            }
            do {
                let content = try String.init(contentsOfFile: path)
                return content
            } catch {
                return ""
            }
        case .leveldbLibrary:
            guard let path = bundle.path(forResource: "leveldb_library", ofType: "txt") else {
                return ""
            }
            do {
                let content = try String.init(contentsOfFile: path)
                return content
            } catch {
                return ""
            }
        case .SCKBase:
            guard let path = bundle.path(forResource: "SCKBaseLicense", ofType: "txt") else {
                return ""
            }
            do {
                let content = try String.init(contentsOfFile: path)
                return content
            } catch {
                return ""
            }
        }
    }
}

extension AppLicense {
    
    static public func all() -> AnySequence<Int> {
        return AnySequence {
            return SectionsGenerator()
        }
    }
    
    public struct SectionsGenerator: IteratorProtocol {
        public var currentSection = 0
        mutating public func next() -> Int? {
            guard let item = AppLicense(rawValue:currentSection) else {
                return nil
            }
            currentSection += 1
            return item.rawValue
        }
    }
    
}
