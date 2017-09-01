//
//  ModalViewController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol ModalViewControllerPanningDelegate {
    
    func modal(viewController: ModalViewController, did pan: CGFloat)
    
    func modal(viewController: ModalViewController, dismissed: Bool, with remaining: CGFloat)
    
}

enum ModalViewControllerInitialPosition {
    case hidden
    case visible
}

enum ModalViewControllerShowBy {
    case animation
    case crossFade
}

enum ModalViewControllePositionRelation {
    case bottom
    case top
    case center
}

enum ModalCornerLayout {
    case topBoth(CGFloat)
    case topBottom(CGFloat)
    case all(CGFloat)
    init() {
        self = .all(5)
    }
}

class LayoutDiferences {
    var top : CGFloat?
    var bottom : CGFloat?
    var sides: CGFloat?
    var corners : ModalCornerLayout?
    
    required init(top : CGFloat?, bottom: CGFloat?) {
        self.top = top
        self.bottom = bottom
    }
    
    convenience init(top : CGFloat?, bottom: CGFloat?, corners: ModalCornerLayout?) {
        self.init(top: top, bottom: bottom)
        self.corners = corners
    }
    
    convenience init(top : CGFloat?, bottom: CGFloat?, sides: CGFloat?) {
        self.init(top: top, bottom: bottom)
        self.sides = sides
    }
    
    convenience init(top : CGFloat?, bottom: CGFloat?, sides: CGFloat?, corners: ModalCornerLayout?) {
        self.init(top : top, bottom: bottom, sides: sides)
        self.corners = corners
    }
}

struct ModalViewControllerLayoutOptions {
    
    var loadsAt : ModalViewControllerInitialPosition
    var appears : ModalViewControllerShowBy
    var movesRelativeTo : ModalViewControllePositionRelation?
    var laysOut : LayoutDiferences?
    
    init(at: ModalViewControllerInitialPosition, appear: ModalViewControllerShowBy) {
        self.loadsAt = at
        self.appears = appear
    }
    
    init(at: ModalViewControllerInitialPosition, appear: ModalViewControllerShowBy, layed: LayoutDiferences?) {
        if let t = layed {
            self.laysOut = t
        }
        self.loadsAt = at
        self.appears = appear
    }
    init(at: ModalViewControllerInitialPosition, appear: ModalViewControllerShowBy, relativeTo: ModalViewControllePositionRelation?, layed: LayoutDiferences?) {
        if let t = layed {
            self.laysOut = t
        }
        self.loadsAt = at
        self.appears = appear
        self.movesRelativeTo = relativeTo
    }
}

class ModalViewController : UIViewController, UIGestureRecognizerDelegate {
    
    var pan = UIPanGestureRecognizer()
    var delegate : ModalViewControllerPanningDelegate?
    var panBlocker : Bool = false
    var stop : Bool = false
    var dismissTime : TimeInterval = 0.4
    
    var new : UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    var panDis : CGFloat {
        get {
            let h = self.new.frame.height / 2
            if let top = topDifference, let bottom = bottomDifference  {
                return h + bottom - top
            } else if let bottom = bottomDifference {
                return h + bottom
            } else {
                return h
            }
        }
    }
    
    var info : CheckoutModalInfo?
    
    private var laysOutOptions : ModalViewControllerLayoutOptions?
    
    private var top = CGFloat()
    private var bottom = CGFloat()
    
    var topDifference : CGFloat?
    
    var bottomDifference : CGFloat?
    
    var sideDifferences = CGFloat()
    
    var corners : CGFloat = 5
    
    private var cornerLayout : ModalCornerLayout?
    
    var finalHeight : CGFloat {
        get {
            var top = CGFloat()
            var bottom = CGFloat()
            if let t = topDifference {
                top = t
            }
            if let bot = bottomDifference {
                bottom = bot
            }
            return self.view.frame.height - (top + bottom)
        }
    }
    
    var totalDifference : CGFloat {
        get {
            guard let top = topDifference else {
                return 0.0
            }
            guard let bottom = bottomDifference else {
                return top
            }
            return (top + bottom)
        }
    }
    
    var differential : CGFloat {
        return CGFloat(20)
    }
    
    var actualCenter : CGFloat {
        get {
            if let opt = laysOutOptions {
                if let asOf = opt.movesRelativeTo {
                    switch asOf {
                    case .bottom:
                        if let top = topDifference, let bot = bottomDifference {
                            return (self.new.frame.height / 2) + top + differential
                        } else if let bot = bottomDifference {
                            return self.view.frame.height - (self.new.frame.height / 2) - bot
                        } else if let top = topDifference {
                            return (self.new.frame.height / 2) + top + differential
                        } else {
                            return (self.view.frame.height / 2) + differential
                        }
                    case .top:
                        if let t = topDifference {
                            return ((finalHeight / 2) + t) + differential
                        } else {
                            return (finalHeight / 2) + differential
                        }
                    case .center:
                        return self.view.frame.height / 2
                    }
                }
            }
            return self.view.frame.height - (finalHeight / 2)
        }
    }
    
    init(info: CheckoutModalInfo?, backgroundColor : UIColor?, loadPosition: ModalViewControllerLayoutOptions?) {
        super.init(nibName: nil, bundle: nil)
        if let inf = info {
            self.info = inf
        }
        self.info = info
        if let back = backgroundColor {
            new.backgroundColor = back
        }
        if let options = loadPosition {
            if let lay = options.laysOut {
                topDifference = lay.top
                bottomDifference = lay.bottom
                if let corn = lay.corners {
                    cornerLayout = corn
                }
                if let side = lay.sides {
                    sideDifferences = side
                }
            }
            self.laysOutOptions = options
        } else {
            self.laysOutOptions = ModalViewControllerLayoutOptions(at: .visible, appear: .animation)
        }
    }
    
    init(backgroundColor : UIColor?, loadPosition: ModalViewControllerLayoutOptions?) {
        super.init(nibName: nil, bundle: nil)
        if let back = backgroundColor {
            new.backgroundColor = back
        }
        if let options = loadPosition {
            if let lay = options.laysOut {
                topDifference = lay.top
                bottomDifference = lay.bottom
            }
            self.laysOutOptions = options
        } else {
            self.laysOutOptions = ModalViewControllerLayoutOptions(at: .visible, appear: .animation)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        view.addSubview(new)
        new.frame.size = CGSize(width: size.width - (sideDifferences * 2), height: finalHeight - differential)
        if let lay = laysOutOptions {
            switch lay.appears {
            case .animation:
                pan.addTarget(self, action: #selector(panning(sender:)))
                new.addGestureRecognizer(pan)
                parseCorners()
                switch lay.loadsAt {
                case .hidden:
                    new.alpha = 0
                case .visible:
                    new.alpha = 1
                }
            case .crossFade:
                //new.frame = CGRect(x: 0, y: 20, width: size.width, height: finalHeight - differential)
                parseCorners()
                pan.addTarget(self, action: #selector(panning(sender:)))
                new.addGestureRecognizer(pan)
                switch lay.loadsAt {
                case .hidden:
                    new.alpha = 0
                case .visible:
                    new.alpha = 1
                }
            }
            if let moves = lay.movesRelativeTo {
                switch moves {
                case .bottom:
                    new.center.y = view.frame.height + (new.frame.height / 2)
                    new.center.x = view.frame.width / 2
                case .top :
                    new.center.y = -(new.frame.height / 2)
                    new.center.x = view.frame.width / 2
                case .center:
                    new.center.y = view.frame.height + (new.frame.height / 2)
                    new.center.x = view.frame.width / 2
                }
            }
        } else {
            parseCorners()
            new.frame = CGRect(x: 0, y: self.view.frame.height, width: size.width, height: finalHeight - differential)
            pan.addTarget(self, action: #selector(panning(sender:)))
            new.addGestureRecognizer(pan)
        }
        set()
    }
    
    func set() {
        
    }
    
    var backColor : CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = (self.backColor != nil ? UIColor.black.withAlphaComponent(self.backColor!) : UIColor.black)
            self.new.center.y = self.actualCenter
        }) { (v) in
            DispatchQueue.main.async {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func parseCorners() {
        
        if bottomDifference != nil && cornerLayout == nil{
            new.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], 10)
        } else {
            if let clay = cornerLayout {
                switch clay {
                case .all(let rad) :
                    new.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], rad)
                case .topBoth(let rad):
                    new.roundCorners([.topLeft, .topRight], rad)
                case .topBottom(let rad):
                    new.roundCorners([.bottomLeft, .bottomRight], rad)
                }
            } else {
                new.roundCorners([.topLeft, .topRight], 10)
            }
        }
        
    }
    
    func dismissCustom(with: CGFloat) {
        UIApplication.shared.isStatusBarHidden = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3 * Double(with), animations: {
                self.new.center.y = self.view.frame.height + (self.new.frame.height / 2)
                self.view.backgroundColor = (self.backColor != nil ? UIColor.black.withAlphaComponent(self.backColor!) : UIColor.black).withAlphaComponent(0)
            }) { (v) in
                self.dismiss(animated: true) {
                    
                    self.stop = false
                    
                }
            }
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let options = laysOutOptions else {
            dismissVisibleAnimated {
                super.dismiss(animated: flag) {
                    if let d = self.delegate {
                        d.modal(viewController: self, dismissed: true, with: (self.view.frame.height - self.new.center.y) / self.view.frame.height)
                        self.delegate = nil
                    }
                    if let comp = completion {
                        UIApplication.shared.isStatusBarHidden = false
                        comp()
                    }
                }
            }
            return
        }
        manageLayoutAndDismissal(options: options, flag: flag) {
            super.dismiss(animated: flag) {
                self.fireDismissedDelegate()
                if let comp = completion {
                    UIApplication.shared.isStatusBarHidden = false
                    comp()
                }
            }
        }
    }
    
    private func manageLayoutAndDismissal(options: ModalViewControllerLayoutOptions, flag: Bool, completion: (() -> Void)? = nil) {
        switch options.loadsAt {
        case .hidden:
            switch options.appears {
            case .animation:
                dismissHiddenAnimated {
                    if let comp = completion {
                        comp()
                    }
                }
            case .crossFade:
                dismissHiddenCrossFade {
                    if let comp = completion {
                        comp()
                    }
                }
            }
        case .visible:
            switch options.appears {
            case .animation:
                dismissVisibleAnimated {
                    if let comp = completion {
                        comp()
                    }
                }
            case .crossFade:
                dismissVisibleCrossFade {
                    if let comp = completion {
                        comp()
                    }
                }
            }
        }
    }
    
    private func fireDismissedDelegate() {
        if let d = self.delegate {
            d.modal(viewController: self, dismissed: true, with: (self.view.frame.height - self.new.center.y) / self.view.frame.height)
            self.delegate = nil
        }
    }
    
    private func dismissVisibleCrossFade(_ completion: @escaping(()->())) {
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: {
            self.new.alpha = 0
            self.view.backgroundColor = UIColor.clear
        }) { (v) in
            completion()
        }
    }
    
    private func dismissVisibleAnimated(_ completion: @escaping(()->())) {
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: {
            self.new.center.y = self.view.frame.height + (self.new.frame.height / 2)
            self.view.backgroundColor = UIColor.clear
        }) { (v) in
            completion()
        }
    }
    
    private func dismissHiddenCrossFade(_ completion: @escaping(()->())) {
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: {
            self.new.alpha = 0
            self.view.backgroundColor = UIColor.clear
        }) { (v) in
            completion()
        }
    }
    
    private func dismissHiddenAnimated(_ completion: @escaping(()->())) {
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: {
            self.new.center.y = self.view.frame.height + (self.new.frame.height / 2)
            self.new.alpha = 0
            self.view.backgroundColor = UIColor.clear
        }) { (v) in
            completion()
        }
    }
    
    var panned : Bool = false
    
    func panning(sender: UIPanGestureRecognizer) {
        if topDifference != nil {
            panningWithTopDifference(sender)
        } else {
            UIApplication.shared.isStatusBarHidden = true
            guard !panBlocker else {
                return
            }
            guard !stop else {
                return
            }
            let anchor = (self.view.frame.height - (self.new.frame.height / 2))
            
            guard new.center.y + sender.translation(in: self.new).y >= anchor else {
                UIApplication.shared.isStatusBarHidden = false
                return
            }
            
            new.center.y = anchor + sender.translation(in: self.new).y
            self.view.backgroundColor = (self.backColor != nil ? UIColor.black.withAlphaComponent(((panDis - sender.translation(in: self.new).y) / panDis) * self.backColor!) : UIColor.black.withAlphaComponent(((panDis - sender.translation(in: self.new).y) / panDis) * self.backColor!))//(self.backColor != nil ? self.backColor! : UIColor.black).withAlphaComponent((panDis - sender.translation(in: self.new).y) / panDis)
            
            if let de = delegate {
                de.modal(viewController: self, did: sender.translation(in: self.new).y)
                panned = true
            }
            if (new.center.y > self.view.frame.height * 0.9) {
                stop = true
                self.dismissCustom(with: (1 - (new.center.y / self.view.frame.height)))
            }
            
            switch sender.state {
            case .ended:
                if (new.center.y > self.view.frame.height * 0.7) {
                    stop = true
                    self.dismissCustom(with: (panDis - sender.translation(in: self.new).y) / panDis)
                } else {
                    if let de = delegate {
                        de.modal(viewController: self, dismissed: false, with: (1 - (view.center.y / self.view.frame.height)))
                    }
                    self.statusBarStatus = false
                    self.statusBarStyle = .lightContent
                    UIApplication.shared.statusBarStyle = .lightContent
                    self.panned = false
                    UIView.animate(withDuration: 0.3, animations: {
                        self.new.center.y = anchor
                        self.setNeedsStatusBarAppearanceUpdate()
                        self.view.backgroundColor = (self.backColor != nil ? UIColor.black.withAlphaComponent(self.backColor!) : UIColor.black)
                    })
                }
                panned = false
            default:
                break
            }
        }
    }
    
    func panningWithTopDifference(_ sender: UIPanGestureRecognizer) {
        UIApplication.shared.isStatusBarHidden = true
        guard !panBlocker else {
            return
        }
        guard !stop else {
            return
        }
        
        let anchor = actualCenter
        
        guard new.center.y + sender.translation(in: self.new).y >= anchor else {
            UIApplication.shared.isStatusBarHidden = false
            return
        }
        
        new.center.y = anchor + sender.translation(in: self.new).y
        
        internalPanning(with: sender.translation(in: self.new).y)
        
        self.view.backgroundColor = (self.backColor != nil ? UIColor.black.withAlphaComponent(((panDis - sender.translation(in: self.new).y) / panDis) * self.backColor!) : UIColor.black.withAlphaComponent(((panDis - sender.translation(in: self.new).y) / panDis) * self.backColor!))//(self.backColor != nil ? self.backColor!.withAlphaComponent(((panDis - sender.translation(in: self.new).y) / panDis)) : UIColor.black)//.withAlphaComponent((panDis - sender.translation(in: self.new).y) / panDis)
        
        if let de = delegate {
            de.modal(viewController: self, did: sender.translation(in: self.new).y)
            panned = true
        }
        if (new.center.y > self.view.frame.height * 0.9) {
            stop = true
            self.dismissCustom(with: (1 - (new.center.y / self.view.frame.height)))
        }
        
        switch sender.state {
        case .ended:
            if (new.center.y > self.view.frame.height * 0.7) {
                stop = true
                let value = (panDis - sender.translation(in: self.new).y) / panDis
                self.dismissCustom(with: value)
                internalDisplace(with: value, closed: true, time: nil)
            } else {
                let value = (1 - (view.center.y / self.view.frame.height))
                if let de = delegate {
                    de.modal(viewController: self, dismissed: false, with: value)
                }
                internalDisplace(with: value, closed: false, time: 0.3)
                self.statusBarStatus = false
                self.statusBarStyle = .lightContent
                UIApplication.shared.statusBarStyle = .lightContent
                self.panned = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.new.center.y = anchor
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.view.backgroundColor = (self.backColor != nil ? UIColor.black.withAlphaComponent(self.backColor!) : UIColor.black)
                })
            }
            panned = false
        default:
            break
        }
    }
    
    func internalPanning(with : CGFloat) {
        
    }
    
    func internalDisplace(with : CGFloat, closed: Bool, time: Double?) {
        
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .slide
        }
    }
    
    private var statusBarStyle : UIStatusBarStyle = .lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusBarStyle
        }
    }
    
    var statusBarStatus : Bool = false
    
    override var prefersStatusBarHidden: Bool {
        get {
            return statusBarStatus
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
