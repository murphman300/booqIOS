//
//  Constrainable.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-07-09.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

public protocol Constrainable {
    var block : ConstraintBlock { get set }
    init(secondaries: Bool)
    init(frame: CGRect, secondaries: Bool)
    init(frame: CGRect, cornerRadius: CGFloat, secondaries: Bool)
    init(frame: CGRect, cornerRadius: CGFloat, secondaries: Bool, callBack: (()->())?)
    func activateConstraints()
}

extension Constrainable where Self : UIView {
    
    public init(secondaries: Bool) {
        self.init(frame: .zero)
        hasSecondaries = secondaries
    }
    
    
    public init(frame: CGRect, secondaries: Bool) {
        self.init(frame: frame)
        hasSecondaries = secondaries
    }
    
    public init(frame: CGRect, cornerRadius: CGFloat, secondaries: Bool) {
        self.init(frame: frame, secondaries: secondaries)
        layer.cornerRadius = cornerRadius
    }
    
    public init(frame: CGRect, cornerRadius: CGFloat, secondaries: Bool, callBack: (()->())?) {
        self.init(frame: frame, secondaries: secondaries)
        layer.cornerRadius = cornerRadius
    }
    
    
    public func activateConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        block.activate()
    }
    
    public var hasSecondaries : Bool {
        get {
            guard block.secondaries != nil else {
                return false
            }
            return true
        } set {
            if newValue {
                block.secondaries = ConstraintBlock()
            } else {
                block.secondaries = nil
            }
        }
    }
    
}



open class SecondaryContraintParameters {
    
    public var element : ConstraintElement
    
    public var vars : ConstraintVariables
    
    public init(element: ConstraintElement, variables: ConstraintVariables) {
        self.element = element
        self.vars = variables
    }
}

public extension UIView {
    
    public func xAxisBy(_ value: ConstraintXAxis) -> NSLayoutXAxisAnchor {
        switch value {
        case .horizontal:
            return self.centerXAnchor
        case .left:
            return self.leadingAnchor
        case .right:
            return self.trailingAnchor
        }
    }
    
    public func yAxisBy(_ value: ConstraintYAxis) -> NSLayoutYAxisAnchor {
        switch value {
        case .vertical:
            return self.centerYAnchor
        case .top:
            return self.topAnchor
        case .bottom:
            return self.bottomAnchor
        }
    }
    
    public func dimensionBy(_ value: ConstraintDimension) -> NSLayoutDimension {
        switch value {
        case .height:
            return self.heightAnchor
        case .width:
            return self.widthAnchor
        }
    }
    
}

public extension Array where Element: ConstrainableElement {
    
    public func toggleConstrainables() {
        for (_, item) in self.enumerated() {
            item.block.toggle()
        }
    }
    
    open var hasOnlyToggleables : Bool {
        for (_, item) in self.enumerated() {
            if !item.canBeToggled {
                return false
            }
        }
        return true
    }
}

open class Label : UILabel, ConstrainableElement {
    
    open var block = ConstraintBlock()
    
    public typealias element = Label
    
}

open class View : UIView, ConstrainableElement {
    
    open var block = ConstraintBlock()
    
    public typealias element = View
    
}

open class Button : UIButton, ConstrainableElement {
    
    open var block =  ConstraintBlock()
    
    public typealias element = Button
    
}

open class ImageView : UIImageView, ConstrainableElement {
    
    open var block =  ConstraintBlock()
    
    public typealias element = ImageView
    
    private var emptyImage: UIImage?
    
    public var hasSecondaries: Bool {
        get {
            guard block.secondaries != nil else {
                return false
            }
            return true
        } set {
            if newValue {
                block.secondaries = ConstraintBlock()
            } else {
                block.secondaries = nil
            }
        }
    }
    
    public convenience init(cornerRadius: CGFloat = 0) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        isUserInteractionEnabled = true
    }
    
    public convenience init(secondaries: Bool, cornerRadius: CGFloat = 0) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.hasSecondaries = secondaries
        isUserInteractionEnabled = true
    }
    
    public convenience init(cornerRadius: CGFloat = 0, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.hasSecondaries = true
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    public convenience init(secondaries: Bool, cornerRadius: CGFloat = 0, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.hasSecondaries = secondaries
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    public convenience init(secondaries: Bool, emptyImage: UIImage? = nil) {
        self.init(cornerRadius: 0, emptyImage: emptyImage)
        self.hasSecondaries = secondaries
    }
    
    public convenience init(secondaries: Bool, emptyImage: UIImage? = nil, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: 0, emptyImage: emptyImage)
        self.hasSecondaries = secondaries
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    public convenience init(secondaries: Bool, cornerRadius: CGFloat, emptyImage: UIImage? = nil, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: emptyImage)
        self.hasSecondaries = secondaries
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func handleTap() {
        tapCallback?()
    }
    
    private var tapCallback: (() -> ())?
    
}

open class TextField : UITextField, ConstrainableElement {
    
    public var textLayout : UIEdgeInsets? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var superSize : CGSize?
    
    public var resignTo: TextField?
    
    public var block = ConstraintBlock()
    
    public typealias element = TextField
    
    override open func drawText(in rect: CGRect) {
        if let lay = textLayout {
            super.drawText(in: CGRect(x: 0 + lay.left, y: 0 + lay.top, width: rect.width - (lay.left + lay.right), height: rect.height - (lay.top + lay.bottom)))
        } else {
            super.drawText(in: rect)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = bounds
        if let lay = textLayout {
            print(newBounds, lay)
            return CGRect(x: 0 + lay.right, y: 0 + lay.top, width: newBounds.width - (lay.left + lay.right), height: newBounds.height - (lay.top + lay.bottom))
        }
        return newBounds
    }
    
    public var toggleToBottomLayer : Void {
        backgroundColor = .clear
        applyBottomBorder()
    }
    
    public func applyBottomBorder() {
        layoutIfNeeded()
        let path = UIBezierPath()
        let bound = bounds
        print(bound.size)
        path.move(to: CGPoint(x: 0, y: bounds.height - 1))
        path.addLine(to: CGPoint(x: bounds.width, y: bound.height - 1))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 1
        shape.strokeColor = colors.lineColor.withAlphaComponent(0.85).cgColor
        layer.addSublayer(shape)
    }
    
    public func applyBottomBorder(_ withHeight: CGFloat) {
        layoutIfNeeded()
        let path = UIBezierPath()
        let bound = bounds
        path.move(to: CGPoint(x: 0, y: bounds.height - withHeight))
        path.addLine(to: CGPoint(x: bounds.width, y: bound.height - withHeight))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = withHeight
        shape.strokeColor = colors.lineColor.withAlphaComponent(0.85).cgColor
        layer.addSublayer(shape)
    }
    
    public func applyBottomBorder(_ withHeight: CGFloat, rounding: String) {
        layoutIfNeeded()
        let path = UIBezierPath()
        let bound = bounds
        path.move(to: CGPoint(x: 0, y: bounds.height - withHeight))
        path.addLine(to: CGPoint(x: bounds.width, y: bound.height - withHeight))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = withHeight
        shape.lineCap = rounding
        shape.strokeColor = colors.lineColor.withAlphaComponent(0.85).cgColor
        layer.addSublayer(shape)
    }
    
}

open class CollectionView : UICollectionView, ConstrainableElement {
    
    open var block = ConstraintBlock()
    
    public typealias element = CollectionView
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        block.secondaries = ConstraintBlock()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
