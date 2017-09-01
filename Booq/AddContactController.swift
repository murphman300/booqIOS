//
//  AddContactController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol AddContactUserResponseDelegate {
    
    func add(user: AddContactController, didAdd: Contact)
    
}

class AddContactController: ContactController, ProfileHeaderActionButtonDelegate {
    
    var userDelegate : AddContactUserResponseDelegate?
    
    var addContact : ActionButton = {
        var b = ActionButton(secondaries: true)
        b.setTitle("Add Contact", for: .normal)
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.touchedColor = colors.purplishColor
        b.alpha = 0
        return b
    }()
    
    convenience init<T:UIViewController, T1: UIViewController>(loadPosition: ModalViewControllerLayoutOptions, delegate: T?, contactDelegate: T1?) where T: ModalViewControllerPanningDelegate, T1: AddContactUserResponseDelegate  {
        self.init(backgroundColor: colors.loginTfBack, loadPosition: loadPosition)
        self.delegate = delegate
        self.userDelegate = contactDelegate
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        label.text = "New Contact"
    }
    
    override func set() {
        super.set()
    }
    
    override func subclassAnimationsOnAppear() {
        UIView.animate(withDuration: 0.35, delay: 0.3, options: .curveEaseIn, animations: {
            self.addContact.alpha = 1
        }) { (v) in
            
        }
    }
    
    override func subclassConstraints() {
        view.addSubview(addContact)
        addContact.block.bottomConstraint = addContact.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
        addContact.block.heightConstraint = addContact.heightAnchor.constraint(equalToConstant: buttonSizes.mainheight * 1.1)
        addContact.block.leftConstraint = addContact.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18)
        addContact.block.rightConstraint = addContact.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
    }
    
    override func subclassActivators() {
        
        addContact.activateConstraints()
    }
    
    override func subclassDelegates() {
        super.subclassDelegates()
        addContact.delegate = self
    }
    
    override func subclassProperties() {
        super.subclassProperties()
        pic.image = #imageLiteral(resourceName: "userMaleIcon")
        pic.contentMode = .scaleAspectFit
        pic.changeColorTo(colors.lineColor.withAlphaComponent(0.7))
        let getPic = UITapGestureRecognizer()
        getPic.addTarget(self, action: #selector(getPicture))
        pic.addGestureRecognizer(getPic)
        addLayers(to: addContact)
    }
    
    func header(button: ActionButton, wasPressed info: Any?) {
        if button == addContact {
            let size = CGSize(width: button.frame.height * 0.9, height: button.frame.height * 0.9)
            addContact.titleLabel?.alpha = 0
            addProgressIndicator(addContact, withSize: addContact.frame.size, size, ColorGradient(colors: UIColor.white.withAlphaComponent(0.0), UIColor.white))
            deleteProgress?.lay.animateCircleTo(duration: 0.4, toValue: 1.0)
            provideNewContact()
        }
    }

    func provideNewContact() {
        guard let n = name.field.text, !n.isEmpty else {
            displayError(name, "Please Provide a Name")
            return
        }
        let contact = Contact()
        contact.name = n
        if let t = last.field.text {
            contact.lastName = t
        }
        if let t = email.field.text {
            contact.email = t
        }
        if let t = dobText {
            contact.dob = t
        } else if let t = dob.field.text, t.characters.count != 0 {
            displayError(dob, nil)
            return
        }
        if let t = phoneText {
            contact.phone = t
        } else if let t = Phone.field.text, t.characters.count != 0 {
            displayError(Phone, nil)
        }
        if let t = postalcode.field.text {
            contact.postalCode = t
        }
        if let t = company.field.text {
            contact.company = t
        }
        if let t = job.field.text {
            contact.jobTitle = t
        }
        FirebaseManager.node.new(contact, pic.image, { (new) in
            guard let it = new else { return }
            if let pi = self.pic.image, let ur = it.picUrl {
                ImageCache.main.add(pi, url: ur, profile: false)
                
            }
            if let d = self.userDelegate {
                DispatchQueue.main.async {
                    d.add(user: self, didAdd: it)
                }
            }
            if let d = self.delegate {
                DispatchQueue.main.async {
                    self.stopRotatingView(self.addContact, "Saved!")
                    self.addContact.titleLabel?.alpha = 1
                    self.dismiss(animated: true, completion: {
                        d.modal(viewController: self, dismissed: true, with: 1.0)
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.stopRotatingView(self.addContact, "Saved!")
                }
            }
            ContactsCD.node.add(it, {
                print("Synced with CD")
            })
        })
        
    }
    
    
    
}


enum DateRegexTemplates: String {
    
    case slashedString = "$1 / $2 / $3"
    
    case DMYslashedString = "$3 / $2 / $1"
    
    case YMDDashedString = "$1 - $2 - $3"
    
    case YMDPartialDashedString = "$1 - $2$3"
    
    case YMDDashedStringCompact = "$1-$2-$3"
    
    case DMYDashedString = "$3 - $2 - $1"
    
    case compact = "$1$2$3"

}

class DateExpression: RegularExpression {
    
    
    convenience public init(date: String) throws {
        try self.init(value: date, pattern: RegexPatterns.date.rawValue, maxlength: nil)
    }
    
    convenience public init(date: String, maxLength: Int?) throws {
        try self.init(value: date, pattern: RegexPatterns.date.rawValue, maxlength: maxLength)
    }
    
    open var DMYSlashed : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: DateRegexTemplates.DMYslashedString.rawValue)
    }
    
    open var YMDDashed : String {
        if self.value.characters.count < 5 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: DateRegexTemplates.compact.rawValue)
        } else if self.value.characters.count < 7 {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: DateRegexTemplates.YMDPartialDashedString.rawValue)
        } else {
            return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: DateRegexTemplates.YMDDashedString.rawValue)
        }
    }
    
    open var YMDDashedCompact : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: DateRegexTemplates.YMDDashedStringCompact.rawValue)
    }
    
    open var DMYDashed : String {
        return self.stringByReplacingMatches(in: value, options: .reportProgress, range: range, withTemplate: DateRegexTemplates.DMYDashedString.rawValue)
    }
    
    var date : Date? {
        get {
            let this = YMDDashedCompact
            return Date().dateFrom(string: this)
        }
    }
    
    var dob : DOB? {
        get {
            guard let d = date else { return nil }
            let new = DOB()
            new.date = d
            return new
        }
    }
    
}

