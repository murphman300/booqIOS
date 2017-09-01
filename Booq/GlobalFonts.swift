//
//  GlobalFonts.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


struct GlobalFonts {
    
    struct bold {
        
        static var regularDescriptionSubTitle : UIFont {
            guard let t = UIFont(name: "Lato-Bold", size: 14) else {
                return UIFont.boldSystemFont(ofSize: 18)
            }
            return t
        }
        
        static var medium : UIFont {
            guard let t = UIFont(name: "Lato-Semibold", size: 18) else {
                return UIFont.boldSystemFont(ofSize: 18)
            }
            return t
        }
        
    }
    
    static var light : UIFont {
        guard let t = UIFont(name: "Lato-Light", size: 18) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var medium : UIFont {
        guard let t = UIFont(name: "Lato-Medium", size: 18) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var controllerTitle : UIFont {
        guard let t = UIFont(name: "Lato-Heavy", size: 28) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var sectionTitle : UIFont {
        guard let t = UIFont(name: "Lato-Heavy", size: 19) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var mainBanner : UIFont {
        guard let t = UIFont(name: "Lato-Regular", size: 30) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var sectionSubtext : UIFont {
        guard let t = UIFont(name: "Lato-Regular", size: 17) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var regularTitle : UIFont {
        guard let t = UIFont(name: "Lato-Regular", size: 16) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var regularSubTitle : UIFont {
        guard let t = UIFont(name: "Lato-Regular", size: 15) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static var regularDescriptionSubTitle : UIFont {
        guard let t = UIFont(name: "Lato-Regular", size: 12) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
}


extension String {
    
    func nsRange(_ of: Range<Index>) -> NSRange {
        let lower = UTF16View.Index(of.lowerBound, within: utf16)
        let upper = UTF16View.Index(of.upperBound, within: utf16)
        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
    }
    
    func stringWithSearch(_ param: String,_ highlights: [String:Any],_ attributes: [String:Any]?) -> NSAttributedString? {
        let lower = self.lowercased()
        let lowerP = param.lowercased()
        let thisString = NSMutableAttributedString(string: self, attributes: attributes)
        if let range = lower.range(of: lowerP) {
            thisString.addAttributes(highlights, range: self.nsRange(range))
        }
        return thisString
    }
    
}

extension UILabel {
    
    func simpleHighlight(_ string: String) {
        let newFontName = self.font.fontName
        let fontSize = self.font.pointSize
        self.hightlightTextWith(string, [NSFontAttributeName: UIFont.init(name: newFontName, size: fontSize + 4) as Any])
    }
    
    func highlight(_ string: String,_ withColor: UIColor) {
        let newFontName = self.font.fontName
        let fontSize = self.font.pointSize
        self.hightlightTextWith(string, [NSFontAttributeName: UIFont.init(name: newFontName, size: fontSize + 4) as Any, NSForegroundColorAttributeName: withColor])
    }
    
    func hightlightTextWith(_ string: String,_ withParams: [String:Any]?) {
        guard let high = withParams else { return }
        if let highlighted = self.text?.stringWithSearch(string, high, [NSFontAttributeName: self.font]) {
            self.attributedText = highlighted
        }
    }
    
}
