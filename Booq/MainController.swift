//
//  MainController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

struct cellSizes {
    static let normal : CGSize = CGSize(width: screen.width, height: buttonSizes.mainheight * 2)//CGSize(width: screen.width - 16, height: buttonSizes.mainheight * 2)
    static let diff : CGSize = CGSize(width: cellSizes.expanded.width - cellSizes.normal.width, height: cellSizes.expanded.height - cellSizes.normal.height)
    static let searchCell : CGSize = CGSize(width: screen.width, height: buttonSizes.mainheight * 1.4)
    static let expanded : CGSize = CGSize(width: screen.width, height: buttonSizes.mainheight * 3.1)
}

class MainController: UIViewController {
    
    var contactID : String = "contact"

    var opaqueView : UIView?
    
    var addContact : EditContactController?
    
    let leftTap = UITapGestureRecognizer()
    
    var menuTap = UITapGestureRecognizer()
    
    var leftButstate : Bool = true
    
    var blockSecondaryKeyboardCall : Bool = false
    
    var blockSecondaryKeyboardHideCall : Bool = false
    
    var searchRect : CGRect = .zero
    
    var notPresented : Bool = true
    
    var dontiMessageKeyboardBugs : Bool = true
    
    var doiMessageKeyboardBugs : Bool = true
    
    var currentlyChanging : [IndexPath:CellSizeState] = [:]
    
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
    
    var main : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(1, 0, (buttonSizes.mainheight * 1.5) + 40, 0)
        layout.minimumInteritemSpacing = 0//8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = colors.accountController.selectorSubviewTab
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    let statusBarView : UIView = {
       var v = UIView()
        v.alpha = 1
        v.backgroundColor = colors.purplishColor
        return v
    }()
    
    var top : View = {
       var v = View(secondaries: true)
        v.alpha = 1
        v.backgroundColor = colors.purplishColor
        return v
    }()
    
    var loading: View = {
        var v = View(secondaries: false)
        v.backgroundColor = colors.purplishColor
        return v
    }()
    
    var topTransitionView : View = {
        var v = View(secondaries: true)
        v.alpha = 0
        return v
    }()
    
    var search : View = {
       var t = View(secondaries: true)
        t.backgroundColor = .clear
        return t
    }()
    
    var leftBut : BarToggler = {
        var b = BarToggler()
        b.color = colors.loginTfBack
        b.toggledColor = colors.lineColor.withAlphaComponent(0.9)
        b.thickness = 1.5
        b.opacity = 1.0
        return b
    }()
    
    var rightBut : ImagedActionButton = {
        var b = ImagedActionButton(layouts: CGSize(width: 0.7, height: 0.7))
        b.backgroundColor = .clear
        b.touchedColor = .clear
        b.untouchedColor = .clear
        b.alpha = 1
        b.actionType = .null
        return b
    }()
    
    var searchField : TextField = {
        var t = TextField(secondaries: true)
        t.backgroundColor = UIColor.clear
        t.tintColor = colors.lineColor.withAlphaComponent(0.9)
        t.textColor = colors.lineColor.withAlphaComponent(0.9)
        t.font = GlobalFonts.regularTitle
        t.alpha = 0
        t.textLayout = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        t.placeholder = "Who are you looking for?"
        t.clearButtonMode = .whileEditing
        return t
    }()
    
    var log : ImageView = {
        var l = ImageView(secondaries: true, cornerRadius: 0.0)
        l.backgroundColor = colors.lightBlueMainColor
        l.contentMode = .scaleAspectFit
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    var searchDisplays : CollectionView = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumInteritemSpacing = 0
        lay.minimumLineSpacing = 0
        var t = CollectionView(frame: .zero, collectionViewLayout: lay)
        t.backgroundColor = colors.accountController.selectorSubviewTab
        t.alpha = 0
        return t
    }()
    
    var searchTip : Label = {
        var l = Label()
        l.textAlignment = .center
        l.font = GlobalFonts.mainBanner
        l.textColor = colors.lineColor.withAlphaComponent(0.6)
        l.text = "Search by Name, Last Name, Company, Job or Email"
        l.numberOfLines = 0
        return l
    }()
    
    var searchBorder : View = {
        var v = View(secondaries: false)
        v.backgroundColor = colors.lineColor.withAlphaComponent(0.8)
        return v
    }()
    
    var appLogo : ImageView = {
        var im = ImageView(secondaries: true, cornerRadius: 0.0)
        return im
    }()

    var contacts : [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        applyInitialsAndViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDisplace(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchReplace), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard notPresented else { return }
        if !App.defaults.configured {
            didAppearWithoutConfiguration()
        } else {
            didAppearWithConfiguration()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObservers()
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reApplyRemovedObservers), name: Notification.Name(rawValue: "ReplaceKeyBObsFromAppDisplacement"), object: nil)
    }
    
    func reApplyRemovedObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ReplaceKeyBObsFromAppDisplacement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchDisplace(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchReplace(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func reestablish() {
        
    }
    
    var statusBarStyle : UIStatusBarStyle = .lightContent
    
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
