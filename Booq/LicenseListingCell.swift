//
//  LicenseListingCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-09-01.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase



protocol LicenseListingDelegate {
    func license(cell: LicenseListingCell, wasPressed: Bool, with: AppLicense)
}

class LicenseListingCell : BaseCell {
    
    var delegate : LicenseListingDelegate?
    
    
    private var position : (Bool, Bool) = (false, false)
    
    var label : Label = {
        var l = Label(secondaries: false)
        return l
    }()
    
    var license : AppLicense? {
        didSet {
            if let l = license {
                parseLicense(l)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        setupForTouchCell()
    }
    
    func setupForTouchCell() {
        
        backgroundColor = colors.loginTfBack
        addSubview(label)
        
        label.font = GlobalFonts.medium
        label.textColor = textColor
        
        addConstraintsWithFormat(format: "H:|-\(frame.height * 0.3)-[v0]-\(frame.height)-|", views: label)
        addConstraintsWithFormat(format: "V:|[v0]|", views: label)
        
        let lay = CAShapeLayer()
        let p = UIBezierPath()
        let x = frame.width - (frame.height * 0.75)
        let y = frame.height * 0.3 * 1.05
        
        let moved = frame.height * 0.3
        
        p.move(to: CGPoint(x: x, y: y))
        p.addLine(to: CGPoint(x: x + (moved / 2), y: y + (moved / 2)))
        p.addLine(to: CGPoint(x: x, y: y + moved))
        
        lay.path = p.cgPath
        lay.strokeColor = lineColor.cgColor
        lay.fillColor = UIColor.clear.cgColor
        lay.lineCap = kCALineCapRound
        lay.lineWidth = 4
        layer.addSublayer(lay)
        applyTouch()
    }
    
    func parseLicense(_ l: AppLicense) {
        label.text = l.title
    }
    
    func applyTouch() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(pressed))
        addGestureRecognizer(tap)
    }
    
    func pressed() {
        if let d = self.delegate, let cell = license {
            d.license(cell: self, wasPressed: true, with: cell)
        }
    }
}
