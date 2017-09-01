//
//  LicenseView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase


class LicenseView : SelectorView {
    
    var license : AppLicense? {
        didSet {
            if let l = license {
                parseLicencse(l)
            }
        }
    }
    
    var label : Label = {
        var l = Label(secondaries: false)
        l.textColor = colors.lineColor.withAlphaComponent(0.8)
        return l
    }()
    
    var image : ImageView = {
        var v = ImageView(secondaries: false, cornerRadius: 0.0)
        return v
    }()
    
    var content : TextView = {
        var v = TextView(secondaries: false)
        v.font = GlobalFonts.regularDescriptionSubTitle
        v.textColor = colors.lineColor.withAlphaComponent(0.95)
        v.layer.cornerRadius = 5
        v.layer.borderColor = colors.lineColor.withAlphaComponent(0.35).cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    override func set(_ frame: CGRect) {
        addSubview(content)
        content.top(self, .top, ConstraintVariables(.top, 10), nil)
        content.left(self, .left, ConstraintVariables(.left, 10), nil)
        content.right(self, .right, ConstraintVariables(.right, -10), nil)
        content.bottom(self, .bottom, ConstraintVariables(.bottom, -10), nil)
        content.activateConstraints()
        content.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        super.set(frame)
    }
    
    func parseLicencse(_ l : AppLicense) {
        content.text = l.content
    }
    
    
}
