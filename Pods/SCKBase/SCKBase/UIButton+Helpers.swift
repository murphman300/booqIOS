//
//  UIButton+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


extension UIButton {
    
    public func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    public func roundedButton(w: CGFloat, h: CGFloat){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: w, height: h))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
    
    public func set(_ title: String, back: UIColor, titleSel: UIColor, titleNorm: UIColor, to: UIView?) {
        backgroundColor = back
        setTitle(title, for: .normal)
        setTitleColor(titleNorm, for: .normal)
        setTitleColor(titleSel, for: .selected)
        if to != nil {
            to?.addSubview(self)
            
        }
    }
    
    public func makeMainButton(_ string: String) {
        self.layer.cornerRadius = 0.5 * bounds.size.width
        self.backgroundColor = colors.mainButtonColor
        self.setTitle(string, for: .normal)
    }
    
    public func addCircleShadow() {
        let shadowBorder = CAGradientLayer()
        shadowBorder.frame = CGRect(x: 0, y: 0, width: mainbuttonconf.size, height: mainbuttonconf.size)
        shadowBorder.cornerRadius = 0.5 * shadowBorder.bounds.size.width
        let color1 = UIColor.black.withAlphaComponent(0.3).cgColor as CGColor
        let color2 = UIColor.clear.cgColor as CGColor
        shadowBorder.colors = [color1, color2]
        shadowBorder.startPoint = CGPoint(x: 0.5, y: 1.0)
        shadowBorder.endPoint = CGPoint(x: 0.5, y: 0.0)
        shadowBorder.locations = [0, 0.5]
        layer.addSublayer(shadowBorder)
    }
    
    public func changeColorTo(_ color: UIColor,_ forState: UIControlState) {
        if let imageToChange = backgroundImage(for: forState)?.withRenderingMode(.alwaysTemplate) {
            setImage(imageToChange, for: forState)
            tintColor = color
        }
    }
    
    public func makeEditProfileAs(_ fromSide: contrastSides) {
        self.sideCircleView(nil)
        contrastBackGround(fromSide, colors.lightBlueMainColor, colors.purplishColor, [0.0, 0.7])
    }
    
    public func makeEditProfileWithConstraints(_ fromSide: ContrastSides,_ h: CGFloat,_ w: CGFloat,_ fadeAt: [CGFloat]) {
        self.sideCircleViewWithConstraints(h)
        contrastBackGroundForViewWithConstraints(fromSide, colors.lightBlueMainColor, colors.purplishColor, fadeAt, h, w)
    }

    public func makeEditProfileWithConstraints(_ fromSide: contrastSides,_ h: CGFloat,_ w: CGFloat,_ fadeAt: [CGFloat]) {
        self.sideCircleViewWithConstraints(h)
        contrastBackGroundForViewWithConstraints(fromSide, colors.lightBlueMainColor, colors.purplishColor, fadeAt, h, w)
    }
    
}
