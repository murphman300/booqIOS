//
//  TextField.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

class TextField : UITextField, Constrainable {
    
    var textLayout : UIEdgeInsets? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var superSize : CGSize?
    
    var resignTo: TextField?
    
    var block = ConstraintBlock()
    
    let shape = CAShapeLayer()
    
    override func drawText(in rect: CGRect) {
        if let lay = textLayout {
            super.drawText(in: CGRect(x: 0 + lay.left, y: 0 + lay.top, width: rect.width - (lay.left + lay.right), height: rect.height - (lay.top + lay.bottom)))
        } else {
            super.drawText(in: rect)
        }
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        if let lay = textLayout {
            super.drawPlaceholder(in: CGRect(x: 0 + lay.left, y: 0 + lay.top, width: rect.width - (lay.left + lay.right), height: rect.height - (lay.top + lay.bottom)))
        } else {
            super.drawPlaceholder(in: rect)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = bounds
        if let lay = textLayout {
            return CGRect(x: 0 + lay.right, y: 0 + lay.top, width: newBounds.width - (lay.left + lay.right), height: newBounds.height - (lay.top + lay.bottom))
        }
        return newBounds
    }
    
    var toggleToBottomLayer : Void {
        backgroundColor = .clear
        applyBottomBorder()
    }
    
    func toggleBottomLayer(_ with: UIColor) {
        backgroundColor = .clear
        applyBottomBorder(with)
    }
    
    func applyBottomBorder() {
        layoutIfNeeded()
        let path = UIBezierPath()
        let bound = bounds
        path.move(to: CGPoint(x: 0, y: bounds.height - 1))
        path.addLine(to: CGPoint(x: bounds.width, y: bound.height - 1))
        shape.path = path.cgPath
        shape.lineWidth = 1
        shape.strokeColor = colors.lineColor.withAlphaComponent(0.85).cgColor
        layer.addSublayer(shape)
    }
    
    func applyBottomBorder(_ with: UIColor) {
        layoutIfNeeded()
        let path = UIBezierPath()
        let bound = bounds
        path.move(to: CGPoint(x: 0, y: bounds.height - 1))
        path.addLine(to: CGPoint(x: bounds.width, y: bound.height - 1))
        shape.path = path.cgPath
        shape.lineWidth = 1
        shape.strokeColor = with.withAlphaComponent(0.85).cgColor
        layer.addSublayer(shape)
    }
    
}

