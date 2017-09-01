//
//  SelectorButton.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-19.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


public class SelectorButton: UIButton {
    
    public var currentURLString : String?
    
    open var shouldUseEmptyImage = true
    
    private var urlStringForChecking: String?
    
    private var emptyImage: UIImage?
    
    private var scheme : SpotitColorScheme?
    
    public convenience init(cornerRadius: CGFloat = 0) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        isUserInteractionEnabled = true
    }
    
    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
    }
    
    public init(title: String?, cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        setTitle(title, for: .normal)
        self.emptyImage = emptyImage
    }
    
    public convenience init(cornerRadius: CGFloat = 0, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addTarget(self, action: #selector(handleTap), for: UIControlEvents.touchUpInside)
    }
    
    public convenience init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: emptyImage)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addTarget(self, action: #selector(handleTap), for: UIControlEvents.touchUpInside)
    }
    
    public convenience init(title: String, cornerRadius: CGFloat = 0, tapCallback: @escaping (() ->())) {
        self.init(title: title, cornerRadius: cornerRadius, emptyImage: nil)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addTarget(self, action: #selector(handleTap), for: UIControlEvents.touchUpInside)
    }
    
    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil, colorScheme: SpotitColorScheme? = nil) {
        super.init(frame: .zero)
        scheme = colorScheme
        parseColorScheme()
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
    }
    
    public init(title: String?, cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil, colorScheme: SpotitColorScheme? = nil) {
        super.init(frame: .zero)
        self.scheme = colorScheme
        parseColorScheme()
        contentMode = .scaleAspectFill
        layer.cornerRadius = cornerRadius
        setTitle(title, for: .normal)
        self.emptyImage = emptyImage
        clipsToBounds = true
    }
    
    public convenience init(title: String?, cornerRadius: CGFloat = 0, colorScheme : SpotitColorScheme?) {
        self.init(title: title, cornerRadius: cornerRadius, emptyImage: nil, colorScheme : colorScheme)
        isUserInteractionEnabled = true
    }
    
    public convenience init(title: String?, cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil, colorScheme : SpotitColorScheme?, tapCallback: @escaping (() ->())) {
        self.init(title: title, cornerRadius: cornerRadius, emptyImage: nil, colorScheme : colorScheme)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addTarget(self, action: #selector(handleTap), for: UIControlEvents.touchUpInside)
    }
    
    open func parseColorScheme() {
        if let s = scheme {
            backgroundColor = s.background
            layer.borderColor = s.border.cgColor
            layer.borderWidth = 1
            if let high = s.isHighlighted {
                setTitleColor(high, for: .highlighted)
            }
            if let sel = s.isSelected {
                setTitleColor(sel, for: .selected)
            }
            if let t = s.titleColor {
                setTitleColor(t, for: .normal)
            }
        }
    }
    
    public func handleTap() {
        tapCallback?()
    }
    
    private var tapCallback: (() -> ())?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


