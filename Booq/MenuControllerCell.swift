//
//  MenuControllerCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol MenuCellDelegate {
    func menu(cell: MenuCell, wasSelected with: AllMenuCells)
}

class DisplayMenuCell : MenuCell {
    
    var image : ImageView = {
        var v = ImageView(secondaries: false, cornerRadius: 0.0)
        return v
    }()
    
    override func setupViews() {
        super.setupViews()
        setupForDisplayCell()
        
    }
    
    override func setupForDisplayCell() {
        borderLess = false
        addSubview(image)
        addSubview(label)
        
        label.font = GlobalFonts.regularTitle
        label.textAlignment = .center
        label.textColor = textColor
        label.numberOfLines = 0
        
        image.horizontal(self, .horizontal, ConstraintVariables(.horizontal, 0).fixConstant(), nil)
        image.width(self, .height, ConstraintVariables(.height, 0.0).m(0.7), nil)
        image.height(self, .height, ConstraintVariables(.height, 0.0).m(0.7), nil)
        image.top(self, .top, ConstraintVariables(.top, 0).fixConstant(), nil)
        
        label.left(self, .left, ConstraintVariables(.left, 0).fixConstant(), nil)
        label.right(self, .right, ConstraintVariables(.right, 0.0).fixConstant(), nil)
        label.bottom(self, .bottom, ConstraintVariables(.bottom, 0.0).fixConstant(), nil)
        label.top(image, .bottom, ConstraintVariables(.top, 0).fixConstant(), nil)
        
        image.activateConstraints()
        label.activateConstraints()
        image.image = #imageLiteral(resourceName: "iconHalf")
        image.contentMode = .scaleAspectFit
    }
    
}

class SelectionMenuCell : MenuCell {
    
    override func setupViews() {
        super.setupViews()
        setupForTouchCell()
    }
    
}

class MenuCell : BaseCell {
    
    var delegate : MenuCellDelegate?
    
    private var _type: MenuListingSections?
    
    private var _allCell : AllMenuCells?
    
    private var _listingValue = String()
    
    private var position : (Bool, Bool) = (false, false)
    
    
    var type : IndexPath? {
        didSet {
            if let t = type {
                let section = MenuSections.list()[t.section]
                var itemCount = Int()
                var items = [Int]()
                for (_, item) in section.enumerated() {
                    _type = item.key
                    items = item.value
                    itemCount = item.value.count
                }
                label.text = _type?.getListingType(items[t.item])
                _allCell = AllMenuCells(rawValue: items[t.item])
            }
        }
    }
    
    var label : Label = {
        var l = Label(secondaries: false)
        return l
    }()
    
    func setupForTouchCell() {
        borderRatio = 0.3
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
    
    func setupForDisplayCell() {
        borderLess = false
        addSubview(label)
        label.font = GlobalFonts.regularTitle
        label.textAlignment = .center
        label.textColor = textColor
        label.numberOfLines = 0
        addConstraintsWithFormat(format: "H:|-\(frame.height * 0.3)-[v0]-\(frame.height * 0.3)-|", views: label)
        addConstraintsWithFormat(format: "V:|[v0]|", views: label)
    }
    
    func applyTouch() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(pressed))
        addGestureRecognizer(tap)
    }
    
    func pressed() {
        if let d = self.delegate, let cell = _allCell {
            d.menu(cell: self, wasSelected: cell)
        }
    }
    
}
