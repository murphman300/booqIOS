//
//  ListingView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

struct TextFieldCombination {
    
    var placeholder : String
    var delegate : UITextFieldDelegate?
    var contactParam : ContactParameter?
    
    init(holder: String) {
        self.placeholder = holder
    }
    
    init<T: UIViewController>(holder: String, delegate: T?) where T: UITextFieldDelegate {
        placeholder = holder
        self.delegate = delegate
    }
}

struct PaddingScheme {
    var title : CGFloat = 0.0
    var input : CGFloat = 0.0
    init(title: CGFloat, input: CGFloat){
        self.title = title
        self.input = input
    }
}

class ListingContainer: View {
    
    var listingTint : UIColor? {
        didSet {
            if let c = self.listingTint {
                label.textColor = c.withAlphaComponent(0.9)
            }
        }
    }
    
    var keyBoard : UIKeyboardType? {
        didSet {
            if let t = self.keyBoard {
                field.keyboardType = t
            }
        }
    }
    
    var label : Label = {
        var v = Label(secondaries: true)
        v.numberOfLines = 0
        v.textColor = colors.lineColor.withAlphaComponent(0.9)
        v.font = GlobalFonts.sectionTitle
        v.textAlignment = .center
        return v
    }()
    
    var field : TextField = {
        var t = TextField(secondaries: true)
        t.textLayout = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        t.textColor = colors.lineColor.withAlphaComponent(0.9)
        t.font = GlobalFonts.sectionSubtext
        t.textAlignment = .center
        return t
    }()
    
    convenience init(title: String, inputs: TextFieldCombination, inline: Bool = false, sidePadding: CGFloat?) {
        self.init(secondaries: true)
        addSubview(label)
        addSubview(field)
        label.text = title.capitalized
        field.placeholder = inputs.placeholder
        guard inline else {
            backgroundColor = .clear
            label.block.topConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 0)
            label.block.heightConstraint = label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
            field.block.topConstraint = field.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0)
            field.block.bottomConstraint = field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            if let pad = sidePadding {
                label.block.leftConstraint = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -pad)
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pad)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -pad)
                field.block.rightConstraint = field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pad)
            } else {
                label.block.leftConstraint = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                field.block.rightConstraint = field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
            }
            field.layer.cornerRadius = 3
            field.layer.borderColor = colors.lineColor.withAlphaComponent(0.75).cgColor
            field.layer.borderWidth = 1
            field.layer.masksToBounds = true
            return
        }
        
        backgroundColor = colors.loginTfBack
        
        label.block.topConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        label.block.bottomConstraint = label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        label.block.widthConstraint = label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        
        
        field.block.topConstraint = field.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        field.block.bottomConstraint = field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        field.block.rightConstraint = field.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        
    }
    
    convenience init(title: String, inputs: TextFieldCombination, inline: Bool = false, paddingScheme: PaddingScheme?) {
        self.init(secondaries: true)
        addSubview(label)
        addSubview(field)
        label.text = title.capitalized
        field.placeholder = inputs.placeholder
        guard inline else {
            backgroundColor = .clear
            label.block.topConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 0)
            label.block.heightConstraint = label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
            field.block.topConstraint = field.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0)
            field.block.bottomConstraint = field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            field.layer.cornerRadius = 3
            if let pad = paddingScheme {
                label.block.leftConstraint = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -pad.title)
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pad.title)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -pad.input)
                field.block.rightConstraint = field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pad.input)
                if pad.input == 0 {
                    field.layer.cornerRadius = 0
                }
            } else {
                field.layer.cornerRadius = 3
                label.block.leftConstraint = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                field.block.rightConstraint = field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
            }
            field.layer.borderColor = colors.lineColor.withAlphaComponent(0.75).cgColor
            field.layer.borderWidth = 1
            field.layer.masksToBounds = true
            return
        }
        
        backgroundColor = colors.loginTfBack
        
        label.block.topConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        label.block.bottomConstraint = label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        if title.isEmpty {
            label.block.widthConstraint = label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0)
            label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
            if let pad = paddingScheme {
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pad.title)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -pad.input)
                if pad.title != 0 {
                    label.textAlignment = .left
                }
            } else {
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            }
        } else {
            label.block.widthConstraint = label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
            if let pad = paddingScheme {
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pad.title)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -pad.input)
                if pad.title != 0 {
                    label.textAlignment = .left
                }
            } else {
                label.block.rightConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
                field.block.leftConstraint = field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            }
        }
        
        field.block.rightConstraint = field.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10)
        field.block.topConstraint = field.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        field.block.bottomConstraint = field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        
    }
    
    func activateConstraints() {
        super.activateConstraints()
        field.activateConstraints()
        label.activateConstraints()
    }
    
    func makeBottom() {
        if let c = listingTint {
            field.toggleBottomLayer(c)
        } else {
            field.toggleToBottomLayer
        }
    }
    
}
