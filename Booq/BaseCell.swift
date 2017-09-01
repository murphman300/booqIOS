//
//  BaseCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase


class BaseCell : UICollectionViewCell {
    
    var lineColor : UIColor = colors.lineColor.withAlphaComponent(0.3)
    
    var textColor : UIColor = colors.lineColor.withAlphaComponent(0.9)
    
    var borderLess : Bool = true
    
    var borderRatio : CGFloat = 0.0
    
    var borderWidth : CGFloat = 0.5
    
    var indexType : (IndexPath, Int)? {
        didSet {
            if let t = indexType {
                parse(t.0.item, t.1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() { }
    
    private func parse(_ position: Int,_ within: Int) {
        guard borderLess else { return }
        guard within > 1 else {
            twoWholeBorders()
            return
        }
        if position == 0 {
            firstInList()
        } else if position == within - 1 {
            lastInList()
        } else {
            withinTheList()
        }
    }
    
    private func twoWholeBorders() {
        let half = borderWidth / 2
        let p = UIBezierPath()
        p.move(to: CGPoint(x: half, y: half))
        p.addLine(to: CGPoint(x: frame.width - half, y: half))
        p.move(to: CGPoint(x: half, y: frame.height - half))
        p.addLine(to: CGPoint(x: frame.width - half, y: frame.height - half))
        addBorderLayer(p)
    }
    
    private func firstInList() {
        let half = borderWidth / 2
        let p = UIBezierPath()
        p.move(to: CGPoint(x: half, y: half))
        p.addLine(to: CGPoint(x: frame.width - half, y: half))
        p.move(to: CGPoint(x: frame.height * borderRatio, y: frame.height - borderWidth))
        p.addLine(to: CGPoint(x: frame.width - half, y: frame.height - borderWidth))
        addBorderLayer(p)
    }
    
    private func withinTheList() {
        let half = borderWidth / 2
        let p = UIBezierPath()
        p.move(to: CGPoint(x: frame.height * borderRatio, y: frame.height - borderWidth))
        p.addLine(to: CGPoint(x: frame.width - half, y: frame.height - borderWidth))
        addBorderLayer(p)
    }
    
    private func lastInList() {
        let half = borderWidth / 2
        let p = UIBezierPath()
        p.move(to: CGPoint(x: half, y: frame.height - half))
        p.addLine(to: CGPoint(x: frame.width - half, y: frame.height - half))
        addBorderLayer(p)
    }
    
    var b : CAShapeLayer?
    
    private func addBorderLayer(_ path: UIBezierPath) {
        guard b == nil else { return }
        b = CAShapeLayer()
        b!.fillColor = UIColor.clear.cgColor
        b!.strokeColor = lineColor.cgColor
        b!.lineWidth = borderWidth
        b!.path = path.cgPath
        layer.addSublayer(b!)
    }
    
}
