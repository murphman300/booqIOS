//
//  SelectorView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-31.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol SelectorViewPanningDelegate {
    func selector(view: SelectorView, didPan: CGFloat)
    func selector(view: SelectorView, dismissed: Bool, with: CGFloat)
}

class SelectorView : View, UIGestureRecognizerDelegate {
    
    private let drag = UIScreenEdgePanGestureRecognizer()
    
    private var anchor : CGFloat = 0.0
    private var stop : Bool = false
    private var panned : Bool = false
    
    private var panDis : CGFloat = 0.0
    
    var disRatio : CGFloat = 0.4
    
    var delegate : SelectorViewPanningDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        set(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ frame: CGRect) {
        drag.edges = [.left]
        drag.delegate = self
        drag.addTarget(self, action: #selector(dragPattern(_:)))
        panDis = frame.width
        anchor = frame.width / 2
        addGestureRecognizer(drag)
    }
    
    func dismissCustom(with: CGFloat) {
        if let d = self.delegate {
            d.selector(view: self, dismissed: true, with: with)
        }
        UIView.animate(withDuration: 0.35 * Double(with), animations: {
            self.center.x = self.frame.width * 1.5
        }) { (v) in
            self.stop = false
        }
    }
    
    @objc private func dragPattern(_ sender: UIScreenEdgePanGestureRecognizer) {
        guard !panned else { return }
        guard !stop else { return }
        let bound = anchor + self.frame.width * disRatio
        
        guard center.x + sender.translation(in: self).x >= anchor else {
            center.x = anchor
            return
        }
        
        guard center.x + sender.translation(in: self).x < bound else {
            stop = true
            let value = (panDis - sender.translation(in: self).x) / panDis
            self.dismissCustom(with: value)
            return
        }
        
        guard !stop else { return }
        center.x = anchor + sender.translation(in: self).x
        
        if let de = delegate {
            de.selector(view: self, didPan: sender.translation(in: self).x)
        }
        switch sender.state {
        case .ended:
            if self.center.x > bound {
                stop = true
                let value = (panDis - sender.translation(in: self).x) / panDis
                self.dismissCustom(with: value)
            } else {
                stop = true
                let value = (1 - (self.center.x / self.frame.width))
                if let de = delegate {
                    de.selector(view: self, dismissed: false, with: value)
                }
                self.panned = false
                UIView.animate(withDuration: 0.35 * Double(value), animations: {
                    self.center.x = self.anchor
                })
                stop = false
            }
            panned = false
        default:
            break
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
