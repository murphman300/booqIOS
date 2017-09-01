//
//  MenuListingCellHeader.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

class MenuListingHeader : BaseCell {
    
    var label : Label = {
        var l = Label(secondaries: false)
        l.textColor = colors.lineColor.withAlphaComponent(0.8)
        return l
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(label)
        label.textColor = colors.lineColor.withAlphaComponent(0.5)
        label.numberOfLines = 0
        label.font = GlobalFonts.bold.medium
        addConstraintsWithFormat(format: "H:|-\(frame.height * 0.3)-[v0]-\(frame.height)-|", views: label)
        addConstraintsWithFormat(format: "V:|-\(20)-[v0]|", views: label)
    }
    
}
