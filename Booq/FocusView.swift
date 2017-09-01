//
//  FocusView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-14.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import AVFoundation

enum CameraType {
    
    case front
    
    case back
    
    init() {
        self = .back
    }
    
    var camera : AVCaptureDevicePosition {
        switch self {
        case .front :
            return .front
        case .back :
            return .back
        }
    }
    
    var toggle : CameraType {
        switch self {
        case .front :
            return .back
        case .back :
            return .front
        }
    }
    
}

class BorderItem {
    
    var corner : CGFloat = 0
    
    var color : UIColor = colors.loginTfBack
    
    var width : CGFloat = 1
    
    init(corner: CGFloat?, color: UIColor?) {
        if let c = corner {
            self.corner = c
        }
        if let c = color {
            self.color = c
        }
    }
    
}

class FocusLayerLayout {
    
    var size: CGSize
    
    var bordered : BorderItem?
    
    var originated : CGPoint?
    
    var centered : Bool {
        return originated == nil
    }
    
    var borderRadius : CGFloat {
        return bordered != nil ? bordered!.corner : 0
    }
    
    init(size: CGSize) {
        self.size = size
    }
    
    func border(_ item: BorderItem) -> FocusLayerLayout {
        bordered = item
        return self
    }
    
    func originating(_ from: CGPoint) -> FocusLayerLayout {
        self.originated = from
        return self
    }
    
}

class FocusView : View {
    
    var focusLayer = CAShapeLayer()
    
    var layout : FocusLayerLayout?
    
    var resultingFocusFrame : CGRect {
        layoutIfNeeded()
        guard let lay = layout else { return .zero }
        guard frame.height == 0 else {
            let size = resultingFocusSize
            guard lay.centered else {
                if let ori = lay.originated {
                    return CGRect(x: ori.x, y: ori.y, width: size.width, height: size.height)
                }
                return .zero
            }
            let x = (frame.width - size.width) / 2
            let y = (frame.height - size.height) / 2
            return CGRect(x: x, y: y, width: size.width, height: size.height)
        }
        return .zero
    }
    
    var resultingFocusSize : CGSize {
        guard let lay = layout else { return .zero }
        if lay.size.width <= 1.0 && lay.size.height <= 1.0 {
            return CGSize(width: frame.width * lay.size.width, height: frame.height * lay.size.height)
        } else {
            return lay.size
        }
    }
    
    convenience init(within: FocusLayerLayout) {
        self.init(secondaries: true)
        self.layout = within
    }
    
    func activateConstraints() {
        super.activateConstraints()
        applyLayout()
    }
    
    func applyLayout() {
        if let lay = self.layout, let border = lay.bordered {
            let size = resultingFocusFrame
            let path = UIBezierPath()
            path.move(to: CGPoint(x: -border.width, y: -border.width))
            path.addLine(to: CGPoint(x: frame.width + border.width, y: -border.width))
            path.addLine(to: CGPoint(x: frame.width + border.width, y: frame.height + border.width))
            path.addLine(to: CGPoint(x: -border.width, y: frame.height + border.width))
            path.addLine(to: CGPoint(x: -border.width, y: -border.width))
            let innerPath = UIBezierPath(roundedRect: size, cornerRadius: border.corner)
            innerPath.append(path)
            focusLayer.path = innerPath.cgPath
            focusLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
            focusLayer.fillRule = kCAFillRuleEvenOdd
            focusLayer.strokeColor = border.color.cgColor
            focusLayer.lineWidth = border.width
            focusLayer.backgroundColor = UIColor.clear.cgColor
            layer.addSublayer(focusLayer)
        }
    }
    
}
