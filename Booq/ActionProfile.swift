//
//  ActionProfile.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-23.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol ActionProfileDelegate {
    
    func action(profile: ActionProfile, didClose: Bool)
    
    func action(profile: ActionProfile, selected: ActionButton, with : Contact, atIndexPath: IndexPath)
    
    func action(profile: ActionProfile, shouldResize count: Int, from: CGSize, withNew : ((CGSize?)->(Bool))?)
    
}

let picViewHeight = buttonSizes.mainheight * 4.5

protocol HybridActionProtocol: ProfileHeaderActionButtonDelegate, ActionProfileDelegate { }

struct ActionProfileSizes {
    
    static let buttonSpacing : CGFloat = 20
    
    static let cellWidth : CGFloat = ((screen.width * 0.9) - 40) / 3
    
    static let cellWidthWithOnePad : CGFloat = ActionProfileSizes.cellWidth + 10
    
    static let picView : CGSize = CGSize(width: (screen.width * 0.9) - 20, height: buttonSizes.mainheight * 4.4)
    
    static let largestSize : CGSize = CGSize(width: (screen.width * 0.9), height: 50 + ActionProfileSizes.picView.height + ((buttonSizes.mainheight + buttonSpacing) * 5))
    
    func takeSize(count: CGFloat) -> CGSize {
        return CGSize(width: (screen.width * 0.9), height: 30 + ActionProfileSizes.picView.height + takeCollectionSize(count: count).height)
    }
    
    func takeCollectionSize(count: CGFloat) -> CGSize {
        let h = 30 + ActionProfileSizes.picView.height + (ActionProfileSizes.cellWidthWithOnePad)
        return CGSize(width: screen.width, height: h)
    }
    
}

enum ContactCapability {
    case email(Any), phone(Any), sms(Any), nav(Any), profile(Any)
}


class ActionProfile: UIView, ProfileHeaderActionButtonDelegate {
    
    var index : IndexPath?
    
    var phoneCall : ImagedActionButton = {
        var b = ImagedActionButton(layouts: CGSize(width: 0.8, height: 0.8))
        b.blockApplyOnImage = true
        b.backgroundColor = .clear
        b.touchedColor = colors.purplishColor
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.image = UIImage(named: "9243")!
        b.imageColor = colors.loginTfBack
        b.contentMode = .scaleAspectFit
        b.setTitle("Make a Call", for: .normal)
        b.titleLabel?.textAlignment = .center
        b.alpha = 0
        return b
    }()
    
    var phoneSMS : ImagedActionButton = {
        var b = ImagedActionButton(layouts: CGSize(width: 0.8, height: 0.8))
        b.blockApplyOnImage = true
        b.backgroundColor = .clear
        b.touchedColor = colors.purplishColor
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.image = #imageLiteral(resourceName: "basic2-4")
        b.imageColor = colors.loginTfBack
        b.contentMode = .scaleAspectFit
        b.setTitle("Send a Text", for: .normal)
        b.titleLabel?.textAlignment = .center
        b.alpha = 0
        return b
    }()
    
    var writeEmail : ImagedActionButton = {
        var b = ImagedActionButton(layouts: CGSize(width: 0.8, height: 0.8))
        b.blockApplyOnImage = true
        b.backgroundColor = .clear
        b.touchedColor = colors.purplishColor
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.image = #imageLiteral(resourceName: "emailIcon")
        b.imageColor = colors.loginTfBack
        b.contentMode = .scaleAspectFit
        b.setTitle("Send an Email", for: .normal)
        b.titleLabel?.textAlignment = .center
        b.alpha = 0
        return b
    }()
    
    var viewProfile : ImagedActionButton = {
        var b = ImagedActionButton(layouts: CGSize(width: 0.8, height: 0.8))
        b.blockApplyOnImage = true
        b.backgroundColor = .clear
        b.touchedColor = colors.purplishColor
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.image = #imageLiteral(resourceName: "userMaleIcon")
        b.imageColor = colors.loginTfBack
        b.contentMode = .scaleAspectFit
        b.setTitle("View Profile", for: .normal)
        b.titleLabel?.textAlignment = .center
        b.alpha = 0
        return b
    }()
    
    var navTo : ImagedActionButton = {
        var b = ImagedActionButton(layouts: CGSize(width: 0.8, height: 0.8))
        b.blockApplyOnImage = true
        b.backgroundColor = .clear
        b.touchedColor = colors.purplishColor
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.imageColor = colors.loginTfBack
        b.contentMode = .scaleAspectFit
        b.alpha = 0
        b.setTitleColor(colors.loginTfBack, for: .normal)
        b.setTitle("Visit", for: .normal)
        return b
    }()
    
    var close : ActionButton = {
        var c = ActionButton(secondaries: true)
        c.setTitle("Back", for: .normal)
        c.setTitleColor(colors.loginTfBack, for: .normal)
        c.backgroundColor = colors.purplishColor
        c.titleLabel?.font = fonts.secButtonBold
        c.titleLabel?.textAlignment = .center
        return c
    }()
    
    var picView : View = {
        var p = View(secondaries: true)
        p.backgroundColor = colors.loginTfBack.withAlphaComponent(1.0)
        return p
    }()
    
    var name : Label = {
        var p = Label(secondaries: true)
        p.font = GlobalFonts.controllerTitle
        p.textColor = colors.lineColor.withAlphaComponent(0.95)
        p.textAlignment = .center
        p.numberOfLines = 0
        return p
    }()
    
    var work : Label = {
        var p = Label(secondaries: true)
        p.font = GlobalFonts.regularTitle
        p.textColor = colors.lineColor.withAlphaComponent(0.9)
        p.textAlignment = .center
        p.numberOfLines = 0
        return p
    }()
    
    var collection : CollectionView = {
        var lay = LastRowCenteredLayout()
        lay.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        lay.scrollDirection = .horizontal
        var coll = CollectionView(frame: .zero, collectionViewLayout: lay)
        coll.backgroundColor = UIColor.clear
        coll.isUserInteractionEnabled = true
        return coll
    }()
    
    var pic : LocalizedImageView = {
        var p = LocalizedImageView(cornerRadius: 0.0)
        p.backgroundColor = UIColor.clear
        p.contentMode = .scaleAspectFit
        return p
    }()
    
    var added : [ImagedActionButton] = []
    var all : [ImagedActionButton] = []
    
    var active = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var buttonSpacing: CGFloat = ActionProfileSizes.buttonSpacing
    
    var toSize = CGSize()
    
    var cellSize = CGSize()
    
    private var indexPath : IndexPath?
    
    var params : [ContactCapability] = []
    
    convenience init<T: UIViewController>(contact: Contact, delegate: T, intendedSize: CGSize, index: IndexPath) where T : HybridActionProtocol {
        self.init(frame: .zero)
        isOpaque = true
        actionDelegate = delegate
        toSize = intendedSize
        currentContact = contact
        let w = ((screen.width * 0.9) - 40) / 3
        cellSize = CGSize(width: w, height: w)
        self.indexPath = index
        
        /*addSubview(phoneCall)
        addSubview(phoneSMS)
        addSubview(writeEmail)
        addSubview(navTo)
        addSubview(viewProfile)*/
        addSubview(picView)
        picView.addSubview(pic)
        picView.addSubview(name)
        picView.addSubview(work)
        picView.addSubview(close)
        addSubview(collection)
        close.delegate = self
        phoneCall.delegate = self
        phoneSMS.delegate = self
        writeEmail.delegate = self
        navTo.delegate = self
        viewProfile.delegate = self
        
        pic.layer.cornerRadius = 10
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        if let p = currentContact.phone, p.compact.characters.count == 10 {
            params.append(.phone(p))
            params.append(.sms(p))
        }
        if let p = currentContact.email, p.characters.count >= 9 {
            do {
                let t = try Email(entry: p)
                params.append(.email(t))
            } catch {
                print("No Email")
            }
        }
        if let p = currentContact.postalCode, p.characters.count == 6 {
            let t = PostalCode()
            t.code = p
            params.append(.nav(t))
        }
        params.append(.profile(currentContact))
        
        /*
        if let p = currentContact.phone, p.compact.characters.count == 10 {
            self.phoneCall.setAttribute("contact_phone", p)
            self.phoneSMS.setAttribute("contact_sms", p)
            phoneCall.image = UIImage(named: "9243")!
            phoneSMS.image = #imageLiteral(resourceName: "basic2-4")
            active += 1
            active += 1
            added.append(self.phoneCall)
            added.append(self.phoneSMS)
            phoneCall.alpha = 1
            phoneSMS.alpha = 1
        }
        if let p = currentContact.email, p.characters.count >= 9 {
            do {
                let t = try Email(entry: p)
                self.writeEmail.setAttribute("contact_email", t)
                writeEmail.image = #imageLiteral(resourceName: "emailIcon")
                active += 1
                added.append(self.writeEmail)
                writeEmail.alpha = 1
            } catch {
                print("No Email")
            }
        }
        if let p = currentContact.postalCode, p.characters.count == 6 {
            let t = PostalCode()
            t.code = p
            self.navTo.setAttribute("contact_loc", t)
            self.navTo.image = #imageLiteral(resourceName: "BatchLogosWhiteStroke_Pin-1")
            added.append(self.navTo)
            active += 1
            navTo.alpha = 1
        }
        if !currentContact.name.isEmpty {
            self.viewProfile.setAttribute("contact_profile", currentContact)
        }
        viewProfile.image = #imageLiteral(resourceName: "userMaleIcon")
        active += 1
        viewProfile.alpha = 1
        added.append(viewProfile)
        all.append(self.phoneCall)
        all.append(self.phoneSMS)
        all.append(self.writeEmail)
        all.append(self.navTo)
        all.append(self.viewProfile)*/
    }
    
    var collSize : CGSize = .zero
    
    func evaluateSize() {
        toSize = ActionProfileSizes().takeCollectionSize(count: CGFloat(params.count))
    }
    
    func set() {
        
        picView.top(self, .top, ConstraintVariables(.top, 0).fixConstant(), nil)
        picView.height(self, .height, ConstraintVariables(.height, ActionProfileSizes.picView.height).fixConstant(), nil)
        picView.right(self, .right, ConstraintVariables(.right, 0).fixConstant(), nil)
        picView.left(self, .left, ConstraintVariables(.left, 0).fixConstant(), nil)
        picView.layer.cornerRadius = 5
        
        collection.top(picView, .bottom, ConstraintVariables(.top, 0).fixConstant(), nil)
        collection.bottom(self, .bottom, ConstraintVariables(.bottom, -layer.cornerRadius).fixConstant(), nil)
        collection.right(self, .right, ConstraintVariables(.right, 0).fixConstant(), nil)
        collection.left(self, .left, ConstraintVariables(.left, 0).fixConstant(), nil)
        
        /*phoneCall.height(self, .height, ConstraintVariables(.height, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        phoneCall.bottom(phoneSMS, .top, ConstraintVariables(.bottom, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .top, variables: ConstraintVariables(.bottom, -self.buttonSpacing).fixConstant())
        }
        phoneCall.right(self, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        phoneCall.left(self, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        phoneCall.apply({
            self.phoneCall.block.switchStates(.height, .height)
            self.phoneCall.block.switchStates(.bottom, .bottom)
        }) {
            self.phoneCall.block.switchStates(.height, .height)
            self.phoneCall.block.switchStates(.bottom, .bottom)
        }
        
        phoneSMS.height(self, .height, ConstraintVariables(.height, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        phoneSMS.bottom(writeEmail, .top, ConstraintVariables(.bottom, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .top, variables: ConstraintVariables(.bottom, -self.buttonSpacing).fixConstant())
        }
        phoneSMS.right(self, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        phoneSMS.left(self, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        phoneSMS.apply({
            self.phoneSMS.block.switchStates(.height, .height)
            self.phoneSMS.block.switchStates(.bottom, .bottom)
        }) {
            self.phoneSMS.block.switchStates(.height, .height)
            self.phoneSMS.block.switchStates(.bottom, .bottom)
        }
        
        
        writeEmail.height(self, .height, ConstraintVariables(.height, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        writeEmail.bottom(navTo, .top, ConstraintVariables(.bottom, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .top, variables: ConstraintVariables(.bottom, -self.buttonSpacing).fixConstant())
        }
        writeEmail.right(self, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        writeEmail.left(self, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        writeEmail.apply({
            self.writeEmail.block.switchStates(.height, .height)
            self.writeEmail.block.switchStates(.bottom, .bottom)
        }) {
            self.writeEmail.block.switchStates(.height, .height)
            self.writeEmail.block.switchStates(.bottom, .bottom)
        }
        
        navTo.height(self, .height, ConstraintVariables(.height, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        navTo.bottom(viewProfile, .top, ConstraintVariables(.bottom, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .top, variables: ConstraintVariables(.bottom, -self.buttonSpacing).fixConstant())
        }
        navTo.right(self, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        navTo.left(self, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        navTo.apply({
            self.navTo.block.switchStates(.height, .height)
            self.navTo.block.switchStates(.bottom, .bottom)
        }) {
            self.navTo.block.switchStates(.height, .height)
            self.navTo.block.switchStates(.bottom, .bottom)
        }
        
        viewProfile.height(self, .height, ConstraintVariables(.height, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        viewProfile.bottom(self, .bottom, ConstraintVariables(.bottom, 0).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .bottom, variables: ConstraintVariables(.bottom, -self.buttonSpacing).fixConstant())
        }
        viewProfile.right(self, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        viewProfile.left(self, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        viewProfile.apply({
            self.viewProfile.block.switchStates(.height, .height)
            self.viewProfile.block.switchStates(.bottom, .bottom)
        }) {
            self.viewProfile.block.switchStates(.height, .height)
            self.viewProfile.block.switchStates(.bottom, .bottom)
        }
        */
        let occupied = active * (buttonSizes.mainheight + buttonSpacing)
        
        let diff = toSize.height - occupied
        
        let m = max(diff, toSize.width * 0.7)
        
        let ratio = (m / 2)
        
        pic.height(picView, .height, ConstraintVariables(.height, 0).m(0.55), nil)
        pic.width(pic, .height, ConstraintVariables(.height, 0).m(1.0), nil)
        pic.horizontal(picView, .horizontal, ConstraintVariables(.horizontal, 0).fixConstant(), nil)
        pic.top(picView, .top, ConstraintVariables(.top, 10).fixConstant(), nil)
        
        work.height(picView, .height, ConstraintVariables(.height, 0).m(0.25), nil)
        work.width(picView, .width, ConstraintVariables(.height, 0).m(1.0), nil)
        work.horizontal(picView, .horizontal, ConstraintVariables(.horizontal, 0).fixConstant(), nil)
        work.bottom(picView, .bottom, ConstraintVariables(.bottom, 0).fixConstant(), nil)
        
        name.width(picView, .width, ConstraintVariables(.height, 0).m(1.0), nil)
        name.horizontal(self, .horizontal, ConstraintVariables(.horizontal, 0).fixConstant(), nil)
        name.top(pic, .bottom, ConstraintVariables(.top, 0).fixConstant(), nil)
        name.bottom(work, .top, ConstraintVariables(.bottom, 0).fixConstant(), nil)
 
        close.height(picView, .height, ConstraintVariables(.height, 0).m(0.225), nil)
        close.left(picView, .left, ConstraintVariables(.left, 10).fixConstant(), nil)
        close.right(pic, .left, ConstraintVariables(.right, -15).fixConstant(), nil)
        close.top(picView, .top, ConstraintVariables(.top, 10).fixConstant(), nil)
        
        if let url = currentContact.picUrl {
            pic.loadFrom(urlString: url)
        } else {
            pic.image = #imageLiteral(resourceName: "userMaleIcon")
            pic.contentMode = .scaleAspectFit
            pic.changeColorTo(colors.lineColor.withAlphaComponent(0.7))
        }
        picView.activateConstraints()
        pic.activateConstraints()
        work.activateConstraints()
        name.activateConstraints()
        close.activateConstraints()
        collection.activateConstraints()
        self.layoutIfNeeded()
        applyContact()
        layerToViewBySize(picView)
        if close.frame.height > 0 {
            close.backgroundColor = UIColor.clear
            close.setTitleColor(colors.purplishColor, for: .normal)
            let h = close.frame.height
            let lay = CAShapeLayer()
            let p = UIBezierPath()
            /*p.move(to: CGPoint(x: h * 0.425, y: h * 0.3))
            p.addLine(to: CGPoint(x: h * 0.225, y: h / 2))
            p.addLine(to: CGPoint(x: h * 0.425, y: h * 0.7))*/
            p.move(to: CGPoint(x: 10, y: h * 0.4))
            p.addLine(to: CGPoint(x: (h * 0.2) + 10, y: h * 0.6))
            p.addLine(to: CGPoint(x: (h * 0.4) + 10, y: h * 0.4))
            lay.path = p.cgPath
            lay.strokeColor = colors.purplishColor.cgColor//colors.loginTfBack.cgColor//colors.purplishColor.cgColor
            lay.lineWidth = 2
            lay.fillColor = UIColor.clear.cgColor
            lay.lineCap = kCALineCapRound
            close.layer.addSublayer(lay)
            /*let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: close.frame.width, height: close.frame.height), cornerRadius: close.frame.height / 2)
            close.layer.shadowPath = path.cgPath
            close.layer.shadowRadius = 5.0
            close.layer.shadowOffset = CGSize(width: 0, height: 2)
            close.layer.shadowColor = UIColor.black.withAlphaComponent(0.75).cgColor
            close.layer.shadowOpacity = 0.6
            close.layer.cornerRadius = close.frame.height / 2*/
            
        }
    }
    
    private var contactElements : [String] = []
    
    func applyContact() {
        collection.register(ActionProfileCell.self, forCellWithReuseIdentifier: "actionCell")
        collection.dataSource = self
        collection.delegate = self
        applyLabels()
    }
    
    
    func applyLabels() {
        if let last = currentContact.lastName {
            name.text = currentContact.name.capitalized + " \(last)"
        }
        if !currentContact.jobTitle.isEmpty {
            work.text = currentContact.jobTitle.capitalized + ((currentContact.company.isEmpty) ? "" : " at \(currentContact.company.capitalized)")
        } else if !currentContact.company.isEmpty {
            work.text = currentContact.company.capitalized
        }
    }
    
    var differentParams : [ImagedActionButton] = []
    var removedParams : [ImagedActionButton] = []
    
    func applyContactFromEdit(_ cont: Contact?) {
        guard let newContact = cont else {
            if let d = self.actionDelegate {
                d.action(profile: self, shouldResize: 0, from: .zero, withNew: { (size) in
                    return true
                })
            }
            return
        }
        currentContact = newContact
        active = 0
        applyLabels()
        /*
        if let p = currentContact.phone, p.compact.characters.count == 10{
            self.phoneCall.setAttribute("contact_phone", p)
            self.phoneSMS.setAttribute("contact_sms", p)
            active += 1
            active += 1
            phoneCall.alpha = 1
            phoneSMS.alpha = 1
            if !added.contains(phoneCall) {
                added.append(phoneCall)
                differentParams.append(phoneCall)
            }
            if !added.contains(phoneSMS) {
                added.append(phoneSMS)
                differentParams.append(phoneSMS)
            }
        } else {
            if let ind = added.index(where: {return $0 == phoneCall}) {
                removedParams.append(phoneCall)
                phoneCall.alpha = 0
                added.remove(at: ind)
            }
            if let ind = added.index(where: {return $0 == phoneSMS}) {
                removedParams.append(phoneSMS)
                phoneSMS.alpha = 0
                added.remove(at: ind)
            }
        }
        if let p = currentContact.email, p.characters.count >= 9 {
            do {
                let t = try Email(entry: p)
                self.writeEmail.setAttribute("contact_email", t)
                writeEmail.image = #imageLiteral(resourceName: "emailIcon")
                active += 1
                writeEmail.alpha = 1
                if !added.contains(writeEmail) {
                    added.append(self.writeEmail)
                    differentParams.append(writeEmail)
                }
            } catch {
                print("No Email")
            }
        } else {
            if let ind = added.index(where: {return $0 == writeEmail}) {
                removedParams.append(writeEmail)
                writeEmail.alpha = 0
                added.remove(at: ind)
            }
        }
        if let p = currentContact.postalCode, p.characters.count == 6 {
            let t = PostalCode()
            t.code = p
            self.navTo.setAttribute("contact_loc", t)
            active += 1
            navTo.alpha = 1
            if !added.contains(navTo) {
                added.append(self.navTo)
                differentParams.append(navTo)
            }
        } else {
            if let ind = added.index(where: {return $0 == navTo}) {
                removedParams.append(navTo)
                navTo.alpha = 0
                added.remove(at: ind)
            }
        }
        
        viewProfile.setAttribute("contact_profile", newContact)
        
        active += 1
        
        for item in differentParams {
            item.block.performMain()
        }
        
        for item in removedParams {
            item.block.performSecondary()
            removeShadow(item)
        }
        */
        params.removeAll()
        if let p = currentContact.phone, p.compact.characters.count == 10 {
            self.phoneCall.setAttribute("contact_phone", p)
            self.phoneSMS.setAttribute("contact_sms", p)
            params.append(.phone(p.compact))
            params.append(.sms(p.compact))
        }
        if let p = currentContact.email, p.characters.count >= 9 {
            do {
                let t = try Email(entry: p)
                params.append(.email(t))
            } catch {
                print("No Email")
            }
        }
        if let p = currentContact.postalCode, p.characters.count == 6 {
            let t = PostalCode()
            t.code = p
            params.append(.nav(t))
        }
        params.append(.profile(currentContact))
        
        evaluateSize()
        if let d = self.actionDelegate {
            d.action(profile: self, shouldResize: added.count, from: toSize, withNew: { (size) in
                if let s = size {
                    print("new size")
                }
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
                self.layerToViewBySize(self.picView)
                return false
            })
        }
        if let url = newContact.picUrl {
            pic.loadFrom(urlString: url)
        } else {
            pic.image = #imageLiteral(resourceName: "userMaleIcon")
            pic.contentMode = .scaleAspectFit
            pic.changeColorTo(colors.lineColor.withAlphaComponent(0.7))
        }
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    var currentContact = Contact()
    
    var to = CGPoint()
    
    func present(_ opaque: UIView) {
        self.backgroundColor = SpotitColors.mercury
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.35, animations: {
                opaque.backgroundColor = UIColor.black.withAlphaComponent(0.45)
                self.center.x = self.to.x
                self.center.y = self.to.y
            }, completion: { (v) in
                let tap = UITapGestureRecognizer()
                tap.addTarget(self, action: #selector(self.triggerClose))
                opaque.addGestureRecognizer(tap)
            })
        }
    }
    
    func triggerClose() {
        guard let d = self.actionDelegate else { return }
        d.action(profile: self, didClose: true)
    }
    
    func removeShadow(_ v: UIView) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width:0, height: 0), cornerRadius: 5).cgPath
        v.layer.shadowPath = path
        v.layer.shadowRadius = 6.0
        v.layer.shadowOffset = CGSize(width: 2, height: 6)
        v.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.cornerRadius = 5
        
    }
    
    func layerToViewBySize(_ v: View) {
        
        let path = UIBezierPath(roundedRect: CGRect(x: -1, y: -1, width: v.frame.width, height: v.frame.height), cornerRadius: 2).cgPath
        v.layer.shadowPath = path
        v.layer.shadowRadius = 6.0
        v.layer.shadowOffset = CGSize(width: 2, height: 2)
        v.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.cornerRadius = 2
        
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 0, y: v.frame.height - 0.25))
        p.addLine(to: CGPoint(x: v.frame.width, y: v.frame.height - 0.25))
        let lay = CAShapeLayer()
        lay.path = p.cgPath
        lay.lineWidth = 0.5
        lay.strokeColor = colors.lineColor.withAlphaComponent(0.95).cgColor
        lay.fillColor = UIColor.clear.cgColor
        v.layer.addSublayer(lay)
    }
    
    func addLayersRelativeConstraints(to: ActionButton) {
        to.actionType = .null
        if let second = to.block.secondaries, let height = second.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: -1, width: frame.width - 20, height: height.constant), cornerRadius: 5).cgPath
            to.layer.shadowPath = path
            to.layer.shadowRadius = 6.0
            to.layer.shadowOffset = CGSize(width: 0, height: 6)
            to.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            to.layer.shadowOpacity = 0.5
            to.layer.cornerRadius = 5
        }
    }
    
    var actionDelegate : ActionProfileDelegate?
    
    func header(button: ActionButton, wasPressed info: Any?) {
        guard let d = self.actionDelegate else { return }
        if button == close {
            d.action(profile: self, didClose: true)
        } else {
            d.action(profile: self, selected: button, with: currentContact, atIndexPath: index!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        close.delegate = nil
        phoneCall.delegate = nil
        phoneSMS.delegate = nil
        writeEmail.delegate = nil
        navTo.delegate = nil
        viewProfile.delegate = nil
    }
    
}

