//
//  ActionProfileCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-29.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase


class LastRowCenteredLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var elementAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard elementAttributes.count > 0 else { return elementAttributes }
        
        elementAttributes = elementAttributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let minY = elementAttributes.last!.frame.minY
        let lastRowAttrs = elementAttributes.reversed().filter { $0.frame.minY == minY }
        
        guard lastRowAttrs.count < 3, let first = elementAttributes.first, let last = elementAttributes.last else {
            return elementAttributes
        }
        
        let horizontalPadding = rect.width - first.frame.minX - last.frame.maxX
        let horizontalShift = horizontalPadding / 2.0
        
        for attrs in lastRowAttrs {
            attrs.frame = attrs.frame.offsetBy(dx: horizontalShift, dy: 0)
        }
        return elementAttributes
    }
    
}

protocol ActionProfileCellDelegate {
    func profile(cell: ActionProfileCell, wasSelected: Bool, withInfo: ActionButton)
}

class ActionProfileCell : BaseCell {
    
    var delegate : ActionProfileCellDelegate?
    
    var attribute : ContactCapability? {
        didSet {
            if let t = attribute {
                switch t {
                case .email(_):
                    label.text = "Email"
                    image.image = #imageLiteral(resourceName: "emailIcon")
                    circle.backgroundColor = UIColor.rgb(red: 218, green: 144, blue: 231)
                case .nav(_):
                    label.text = "Visit"
                    image.image = #imageLiteral(resourceName: "mapicon")
                    circle.backgroundColor = UIColor.rgb(red: 235, green: 178, blue: 68)
                case .phone(_):
                    label.text = "Call"
                    image.image = UIImage(named: "9243")
                    circle.backgroundColor = UIColor.rgb(red: 119, green: 231, blue: 153)
                case .profile(_):
                    label.text = "View Profile"
                    image.image = #imageLiteral(resourceName: "userMaleIcon")
                    circle.backgroundColor = colors.purplishColor.withAlphaComponent(0.7)
                case .sms(_):
                    label.text = "Text"
                    image.image = #imageLiteral(resourceName: "basic2-4")
                    circle.backgroundColor = UIColor.rgb(red: 96, green: 217, blue: 231)
                }
                image.contentMode = .scaleAspectFit
                image.changeColorTo(UIColor.white)
            }
        }
    }
    
    var circle = View()
    
    var image : ImageView = {
        var image = ImageView()
        return image
    }()
    
    var label : Label = {
        var l = Label()
        l.font = GlobalFonts.regularSubTitle
        l.textColor = colors.lineColor.withAlphaComponent(0.8)
        l.textAlignment = .center
        return l
    }()
    
    override func setupViews() {
        super.setupViews()
        isUserInteractionEnabled = true
        circle.backgroundColor = UIColor.rgb(red: 68, green: 78, blue: 168)
        
        addSubview(circle)
        circle.addSubview(image)
        addSubview(label)
        
        circle.height(self, .height, ConstraintVariables(.height, 0).m(0.7), nil)
        circle.width(circle, .height, ConstraintVariables(.height, 0).m(1.0), nil)
        circle.horizontal(self, .horizontal, ConstraintVariables(.horizontal, 0).m(1.0), nil)
        circle.top(self, .top, ConstraintVariables(.height, 0).fixConstant(), nil)
        circle.layer.cornerRadius = frame.height * 0.35
        
        image.height(circle, .height, ConstraintVariables(.height, 0).m(0.6), nil)
        image.width(circle, .height, ConstraintVariables(.height, 0).m(0.6), nil)
        image.horizontal(circle, .horizontal, ConstraintVariables(.horizontal, 0).m(1.0), nil)
        image.vertical(circle, .vertical, ConstraintVariables(.vertical, 0).m(1.0), nil)
        
        label.top(circle, .bottom, ConstraintVariables(.top, 0).fixConstant(), nil)
        label.left(self, .left, ConstraintVariables(.left, 0).fixConstant(), nil)
        label.right(self, .right, ConstraintVariables(.right, 0).fixConstant(), nil)
        label.bottom(self, .bottom, ConstraintVariables(.bottom, 0).fixConstant(), nil)
        
        circle.activateConstraints()
        image.activateConstraints()
        label.activateConstraints()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selected))
        circle.addGestureRecognizer(tap)
    }
    
    func selected() {
        if let d = delegate {
            if let attribute = self.attribute {
                let button = ActionButton()
                switch attribute {
                case .email(let v):
                    button.setAttribute("contact_email", v)
                case .nav(let v):
                    button.setAttribute("contact_loc", v)
                case .phone(let v):
                    button.setAttribute("contact_phone", v)
                case .profile(let v):
                    button.setAttribute("contact_profile", v)
                case .sms(let v):
                    button.setAttribute("contact_sms", v)
                }
                d.profile(cell: self, wasSelected: true, withInfo: button)
            }
        }
    }
    
    /*func setAttribute(_ key: String,_ value: Any) {
        if attributes == nil {
            attributes = [:]
        }
        attributes?[key] = value
    }
    
    func attribute(_ key: String) -> String {
        guard let att = attributes, let value = att[key] as? String else {
            return ""
        }
        return value
    }*/
}
