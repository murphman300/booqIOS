//
//  MenuListings.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

private var versionString : String {
    get {
        guard let st = Bundle.main.infoDictionary, let dict = st["CFBundleShortVersionString"] as? String else {
            return "0.8.1"
        }
        return dict
    }
}

public struct MenuSections {
    static func list() -> [[MenuListingSections:[Int]]] {
        return MenuListingSections.provideAll()
    }
}

enum BetaApp : Int {
    
    case agreement = 4
    
    var value : String {
        switch self {
        case .agreement:
            return "Beta User Guidelines"
        }
    }
    
    
}

enum AllMenuCells : Int {
    case privacy = 0
    case terms = 1
    case licenses = 2
    case appState = 3
    case agreement = 4
    
    var value : String {
        switch self {
        case .privacy:
            return LegalMenuCells.privacy.value()
        case .terms:
            return LegalMenuCells.terms.value()
        case .licenses:
            return LegalMenuCells.licenses.value()
        case .appState:
            return ""
        case .agreement:
            return BetaApp.agreement.value
        }
    }
    
}

enum LegalMenuCells : Int {
    
    case privacy = 0
    case terms = 1
    case licenses = 2
    
    func value() -> String {
        switch self {
        case .privacy:
            return "privacy policy".localizedCapitalized
        case .terms:
            return "Terms of Service".localizedCapitalized
        case .licenses:
            return "licenses".localizedCapitalized
        }
    }
}

enum BottomMenuCells : Int {
    
    case appState = 3
    
    func value() -> String {
        switch self {
        case .appState :
            return "Version \(versionString)".localizedCapitalized
        }
    }
}

fileprivate var betaApp : Bool = true

enum MenuListingSections: Int {
    
    case beta = 0
    case legal = 1
    case bottom = 2
    
    var value: String {
        switch self {
        case .legal:
            return "legal".localizedCapitalized
        case .bottom:
            return "".localizedCapitalized
        case .beta:
            return "beta".localizedCapitalized
        }
    }
    
    func getListingType(_ value: Int) -> String? {
        switch self {
        case .legal:
            guard let result = LegalMenuCells(rawValue: value) else { return nil }
            return result.value()
        case .bottom:
            guard let result = BottomMenuCells(rawValue: value) else { return nil }
            return result.value()
        case .beta:
            guard let result = BetaApp(rawValue: value) else { return nil }
            return result.value
        }
    }
    
    var listings : [Int] {
        switch self {
        case .legal:
            return LegalMenuCells.all().array()
        case .bottom:
            return BottomMenuCells.all().array()
        case .beta:
            return BetaApp.all().array()
        }
    }
    
    static func provideAll() -> [[MenuListingSections:[Int]]] {
        var these = MenuListingSections.all()
        var resulting : [[MenuListingSections:[Int]]] = []
        if !betaApp {
            these = these.dropFirst()
        }
        for item in these {
            let new = [item:item.listings]
            resulting.append(new)
        }
        return resulting
    }
}

extension AnySequence where Element == Int {
    
    func array<Element>() -> [Element] {
        return self.map { (first) -> Element in
            return first as! Element
        }
    }
    
}

extension BetaApp {
    
    static public func all() -> AnySequence<Int> {
        return AnySequence {
            return SectionsGenerator()
        }
    }
    
    public struct SectionsGenerator: IteratorProtocol {
        public var currentSection = 4
        mutating public func next() -> Int? {
            guard let item = BetaApp(rawValue:currentSection) else {
                return nil
            }
            currentSection += 1
            return item.rawValue
        }
    }
    
}

extension MenuListingSections {
    
    static public func all() -> AnySequence<MenuListingSections> {
        return AnySequence {
            return SectionsGenerator()
        }
    }
    
    public struct SectionsGenerator: IteratorProtocol {
        public var currentSection = 0
        mutating public func next() -> MenuListingSections? {
            guard let item = MenuListingSections(rawValue:currentSection) else {
                return nil
            }
            currentSection += 1
            return item
        }
    }
    
}

extension LegalMenuCells {
    
    static public func all() -> AnySequence<Int> {
        return AnySequence {
            return SectionsGenerator()
        }
    }
    
    public struct SectionsGenerator: IteratorProtocol {
        public var currentSection = 0
        mutating public func next() -> Int? {
            guard let item = LegalMenuCells(rawValue:currentSection) else {
                return nil
            }
            currentSection += 1
            return item.rawValue
        }
    }
    
}

extension BottomMenuCells {
    static public func all() -> AnySequence<Int> {
        return AnySequence {
            return SectionsGenerator()
        }
    }
    
    public struct SectionsGenerator: IteratorProtocol {
        public var currentSection = 3
        mutating public func next() -> Int? {
            guard let item = BottomMenuCells(rawValue:currentSection) else {
                return nil
            }
            currentSection += 1
            return item.rawValue
        }
    }
    
}

