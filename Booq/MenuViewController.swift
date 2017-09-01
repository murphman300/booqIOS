//
//  MenuViewController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol MenuControllerDelegate {
    func menu(controller: MenuViewController, isClosing: Bool)
    func menu(controller: MenuViewController, didClose: Bool)
}

class MenuViewController: UIViewController {
    
    private var opaqued : Bool = true
    
    var menuListingHeaderID = "menuListingHeaderID"
    
    var delegate : MenuControllerDelegate?
    
    var license : LicenseView?
    
    var this : ActionButton = {
        var b = ActionButton(secondaries: true)
        b.backgroundColor = colors.purplishColor
        b.setTitle("", for: .normal)
        b.touchedColor = colors.accountController.selectorSubviewTab
        b.untouchedColor = colors.purplishColor
        b.setTitleColor(.darkGray, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.alpha = 0
        return b
    }()
    
    var add : ActionButton = {
        var b = ActionButton(secondaries: true)
        b.backgroundColor = colors.purplishColor
        b.setTitle("", for: .normal)
        b.touchedColor = colors.accountController.selectorSubviewTab
        b.untouchedColor = colors.purplishColor
        b.setTitleColor(.darkGray, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.alpha = 0
        return b
    }()
    
    var appLogo : ImageView = {
        var im = ImageView(secondaries: true, cornerRadius: 0.0)
        im.alpha = 0
        return im
    }()
    
    var leftBut : BarToggler = {
        var b = BarToggler()
        b.color = colors.loginTfBack
        b.toggledColor = colors.purplishColor
        b.thickness = 1.5
        b.opacity = 1.0
        b.alpha = 0
        return b
    }()
    
    var listing : CollectionView = {
        var lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .vertical
        lay.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0)
        var c = CollectionView(frame: .zero, collectionViewLayout: lay)
        c.backgroundColor = UIColor.clear
        c.isUserInteractionEnabled = true
        return c
    }()
    
    var container: View = {
       var c = View(secondaries: false)
        c.backgroundColor = SpotitColors.creamy
        return c
    }()
    
    var top: View = {
        var c = View(secondaries: false)
        c.backgroundColor = colors.loginTfBack
        return c
    }()
    
    var topMain: View = {
        var c = View(secondaries: false)
        c.backgroundColor = UIColor.clear
        c.alpha = 1
        return c
    }()
    
    var back : ActionButton = {
        var c = ActionButton(secondaries: true)
        c.setTitle("Back", for: .normal)
        c.setTitleColor(colors.purplishColor, for: .normal)
        c.backgroundColor = UIColor.clear
        c.titleLabel?.font = GlobalFonts.medium
        c.titleLabel?.textAlignment = .center
        return c
    }()
    
    var selectedTitle : Label = {
        var l = Label(secondaries: false)
        l.font = GlobalFonts.bold.medium
        l.textColor = colors.purplishColor.withAlphaComponent(0.9)
        l.textAlignment = .center
        return l
    }()
    
    var secondSelectedTitle : Label = {
        var l = Label(secondaries: false)
        l.font = GlobalFonts.bold.medium
        l.textColor = colors.purplishColor.withAlphaComponent(0.9)
        l.textAlignment = .center
        l.alpha = 0
        return l
    }()
    
    var topSelection: View = {
        var c = View(secondaries: false)
        c.backgroundColor = UIColor.clear
        c.alpha = 0
        return c
    }()
    
    var selection: SelectorView?

    var searchHeight : CGFloat {
        return buttonSizes.mainheight * 1.1
    }
    
    var topHeight : CGFloat {
        return buttonSizes.mainheight * 1.2
    }
    
    
    var newH : CGFloat {
        return self.view.frame.width * 0.1575
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        set()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        animateVisible()
    }
    
    func set() {
        view.addSubview(container)
        container.addSubview(top)
        top.addSubview(topSelection)
        topSelection.addSubview(back)
        topSelection.addSubview(selectedTitle)
        topSelection.addSubview(secondSelectedTitle)
        container.addSubview(listing)
        view.addSubview(this)
        view.addSubview(add)
        self.view.addSubview(appLogo)
        self.view.addSubview(leftBut)
        
        leftBut.frame.size = CGSize(width: searchHeight * 0.45, height: searchHeight * 0.4)
        leftBut.center.x = searchHeight * 0.6
        leftBut.center.y = 20 + topHeight - (searchHeight / 2)
        leftBut.form()
        leftBut.type = .bottomArrow
        appLogo.frame.size = CGSize(width: searchHeight * 2, height: searchHeight)
        appLogo.center.x = view.frame.width / 2
        appLogo.center.y = 20 + (topHeight / 2)
        appLogo.image = #imageLiteral(resourceName: "booqAppTextCursive")
        appLogo.contentMode = .scaleAspectFit
        leftBut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAll)))
        
        container.frame.size = CGSize(width: view.frame.width, height: view.frame.height - 20)
        container.center.x = view.frame.width / 2
        container.center.y = view.frame.height + (container.frame.size.height / 2)
        container.roundCorners([.topLeft, .topRight], 10)
        
        top.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: newH)
        
        topSelection.frame = CGRect(x: top.frame.width * 0.35, y: 0, width: top.frame.width, height: top.frame.height)
        
        back.left(topSelection, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        back.width(topSelection, .width, ConstraintVariables(.width, 0).m(0.25), nil)
        back.bottom(topSelection, .bottom, ConstraintVariables(.bottom, 0).fixConstant(), nil)
        back.top(topSelection, .top, ConstraintVariables(.top, 0).fixConstant(), nil)
        
        selectedTitle.left(back, .right, ConstraintVariables(.left, 0).fixConstant(), nil)
        selectedTitle.width(topSelection, .width, ConstraintVariables(.width, 0).m(0.5), nil)
        selectedTitle.bottom(topSelection, .bottom, ConstraintVariables(.bottom, 0).fixConstant(), nil)
        selectedTitle.top(topSelection, .top, ConstraintVariables(.top, 0).fixConstant(), nil)
        
        secondSelectedTitle.frame = CGRect(x: topSelection.frame.width / 2, y: 0, width: topSelection.frame.width / 2, height: topSelection.frame.height)
        
        back.activateConstraints()
        selectedTitle.activateConstraints()
        
        if topSelection.frame.height > 0 {
            let h = topSelection.frame.height
            let lay = CAShapeLayer()
            let p = UIBezierPath()
            let dist = h * 0.25
            let width = dist / 2
            let half = h / 2
            p.move(to: CGPoint(x: width + 10, y: half - (dist / 2)))
            p.addLine(to: CGPoint(x: 10, y: half))
            p.addLine(to: CGPoint(x: width + 10, y: half + (dist / 2)))
            lay.path = p.cgPath
            lay.strokeColor = colors.purplishColor.cgColor
            lay.lineWidth = 3
            lay.fillColor = UIColor.clear.cgColor
            lay.lineCap = kCALineCapRound
            back.layer.addSublayer(lay)
            let t = UITapGestureRecognizer(target: self, action: #selector(backToMain))
            back.addGestureRecognizer(t)
        }
        
        let half : CGFloat = 0.65 / 2
        let p = UIBezierPath()
        p.move(to: CGPoint(x: half, y: top.frame.height - 0.65))
        p.addLine(to: CGPoint(x: top.frame.width - half, y: top.frame.height - 0.65))
        
        let b = CAShapeLayer()
        b.fillColor = UIColor.clear.cgColor
        b.strokeColor = colors.lineColor.withAlphaComponent(0.4).cgColor
        b.lineWidth = 0.65
        b.path = p.cgPath
        top.layer.addSublayer(b)
        
        listing.frame = CGRect(x: 0, y: newH, width: container.frame.width, height: container.frame.height - newH)
        listing.register(MenuListingHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: menuListingHeaderID)
        listing.register(DisplayMenuCell.self, forCellWithReuseIdentifier: "displayCell")
        listing.register(SelectionMenuCell.self, forCellWithReuseIdentifier: "selectionCell")
        listing.delegate = self
        listing.dataSource = self
        
    }
    
    
    func animateVisible() {
        let newH = self.newH * 0.9
        UIView.animate(withDuration: 0.35, animations: {
            self.appLogo.changeColorTo(colors.purplishColor)
            self.appLogo.alpha = 1
            self.leftBut.alpha = 1
            self.container.center.y = self.view.frame.height - (self.container.frame.size.height / 2)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.appLogo.frame.size = CGSize(width: newH * 2, height: newH)
            self.appLogo.center.y = (self.newH / 2) + 20
            self.appLogo.center.x = self.view.frame.width / 2
        }) { (v) in
            self.leftBut.select()
            UIView.animate(withDuration: 0.35, animations: {
                self.view.backgroundColor = UIColor.white
            }, completion: { (v) in
                
            })
        }
    }
    
    func dismissAll() {
        self.leftBut.deselect()
        if let d = delegate {
            d.menu(controller: self, isClosing: true)
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.appLogo.frame.size = CGSize(width: self.searchHeight * 2, height: self.searchHeight)
            self.appLogo.center.x = self.view.frame.width / 2
            self.appLogo.center.y = 20 + (self.topHeight / 2)
            self.appLogo.changeColorTo(colors.loginTfBack)
            self.view.backgroundColor = UIColor.clear
            self.container.center.y = self.view.frame.height + (self.container.frame.size.height / 2)
        }, completion: { (v) in
            self.dismiss(animated: false, completion: {
                
                if let d = self.delegate {
                    d.menu(controller: self, didClose: true)
                }
            })
        })
        UIView.animate(withDuration: 0.35, animations: {
            
        }) { (v) in
            
        }
    }
    
    var statusBarStyle : UIStatusBarStyle = UIStatusBarStyle.default
    
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
}
