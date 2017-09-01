//
//  ImagedActionButton.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase


class ImagedActionButton : ActionButton {
    
    var blockApplyOnImage : Bool = false
    
    var image : UIImage? {
        didSet {
            if blockApplyOnImage {
                return
            }
            applyImage()
        }
    }
    
    var imageInsets : CGSize?
    
    var imageColor : UIColor? {
        didSet {
            if let c = self.imageColor {
                imageV.changeColorTo(c)
            }
        }
    }
    
    var color : UIColor? {
        didSet {
            if let text = color {
                imageV.changeColorTo(text)
            }
        }
    }
    
    var imageShouldHaveUnderLyingShadow : Bool = false
    
    private var activator : (()->())?
    
    var imageV : ImageView = {
        var i = ImageView(secondaries: false, emptyImage: nil)
        i.backgroundColor = UIColor.clear
        return i
    }()
    
    convenience init(image: UIImage) {
        self.init(secondaries: true)
        addSubview(imageV)
        imageV.block.vertical = imageV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        imageV.block.horizontal = imageV.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        imageV.block.widthConstraint = imageV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        imageV.block.heightConstraint = imageV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        self.imageV.image = image
        self.imageV.contentMode = .scaleAspectFit
        imageV.activateConstraints()
        
    }
    
    convenience init(image: UIImage, layouts: CGSize?) {
        if let layout = layouts, (layout.width <= 1.0 && layout.height <= 1.0) {
            self.init(secondaries: true)
            self.imageV.image = image
            self.imageInsets = layout
        } else {
            self.init(image: image)
        }
    }
    
    convenience init(layouts: CGSize) {
        if layouts.width <= 1.0 && layouts.height <= 1.0 {
            self.init(secondaries: true)
            self.imageInsets = layouts
        } else {
            self.init(secondaries: true)
        }
    }
    
    func applyImage() {
        addSubview(imageV)
        if let lay = self.imageInsets {
            if lay.width == 0 && lay.height == 0 {
                imageV.block.vertical = imageV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
                imageV.block.leftConstraint = imageV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
                imageV.block.widthConstraint = imageV.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
                imageV.block.heightConstraint = imageV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
            } else {
                imageV.block.vertical = imageV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
                imageV.block.leftConstraint = imageV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
                imageV.block.widthConstraint = imageV.widthAnchor.constraint(equalTo: heightAnchor, multiplier: lay.width)
                imageV.block.heightConstraint = imageV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: lay.height)
                /*
                imageV.block.vertical = imageV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
                imageV.block.horizontal = imageV.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
                imageV.block.widthConstraint = imageV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: lay.width)
                imageV.block.heightConstraint = imageV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: lay.height)*/
            }
        } else {
            imageV.block.vertical = imageV.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
            imageV.block.horizontal = imageV.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            imageV.block.widthConstraint = imageV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
            imageV.block.heightConstraint = imageV.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        }
        self.imageV.image = image
        self.imageV.contentMode = .scaleAspectFit
        if let c = imageColor {
            imageV.changeColorTo(c)
        }
        activator = {
            self.imageV.activateConstraints()
        }
    }
    
    func activateConstraints() {
        super.activateConstraints()
        activator?()
        layoutIfNeeded()
        if imageShouldHaveUnderLyingShadow, let h = block.heightConstraint, let w = block.widthConstraint {
            if let lays = imageInsets {
                let extra : CGFloat = 0.2
                let rect = CGRect(x: w.constant * lays.width * extra, y: h.constant * lays.height * extra, width: w.constant * lays.width * (1 - 2*extra), height: h.constant * lays.height * (1 - 2*extra))
                if rect.width == rect.height {
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: w.constant / 2).cgPath
                    imageV.layer.shadowPath = path
                    imageV.layer.shadowRadius = 10.0
                    imageV.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                    imageV.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
                    imageV.layer.shadowOpacity = 0.6
                } else {
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
                    imageV.layer.shadowPath = path
                    imageV.layer.shadowRadius = 10.0
                    imageV.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                    imageV.layer.shadowColor = UIColor.black.cgColor
                    imageV.layer.shadowOpacity = 0.6
                }
            } else {
                let rect = CGRect(x: 0, y: 0, width: h.constant, height: w.constant)
                if rect.width == rect.height {
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: w.constant / 2).cgPath
                    imageV.layer.shadowPath = path
                    imageV.layer.shadowRadius = 6.0
                    imageV.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                    imageV.layer.shadowColor = UIColor.black.cgColor
                    imageV.layer.shadowOpacity = 0.6
                } else {
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
                    imageV.layer.shadowPath = path
                    imageV.layer.shadowRadius = 6.0
                    imageV.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                    imageV.layer.shadowColor = UIColor.black.cgColor
                    imageV.layer.shadowOpacity = 0.6
                }
            }
        }
    }
    
}
