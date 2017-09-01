//
//  EditContactController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import CoreGraphics

protocol EditContactUserResponseDelegate {
    
    func edit(user: EditContactController, didEdit: Contact, at: IndexPath)
    
    func edit(user: EditContactController, didDelete: Contact, at: IndexPath)
    
}

class EditContactController: ContactController, ProfileHeaderActionButtonDelegate, ContactControllerInputDelegate {
    
    var userDelegate : EditContactUserResponseDelegate?
    
    var currentlyEditing : Bool = false
    
    private var currentContact : Contact?
    
    private var editingContact : EditContactNode?
    
    private var currentIndex : IndexPath?
    
    var deleteContact : ActionButton = {
        var b = ActionButton(secondaries: true)
        b.setTitle("Delete", for: .normal)
        b.untouchedColor = SpotitColors.errorColors.responseRed//UIColor.rgb(red: 0, green: 128, blue: 255)
        b.touchedColor = SpotitColors.errorColors.responseRedDarker
        b.alpha = 0
        return b
    }()
    
    var edit : ActionButton = {
        var b = ActionButton(secondaries: true)
        b.setTitle("Edit", for: .normal)
        b.backgroundColor = UIColor.clear
        b.alpha = 1
        b.setTitleColor(colors.purplishColor, for: .normal)
        return b
    }()
    
    var cancelEdit : ActionButton = {
        var b = ActionButton(secondaries: true)
        b.setTitle("Cancel", for: .normal)
        b.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        b.touchedColor = colors.purplishColor
        b.alpha = 0
        return b
    }()
    
    var opaqueView : UIView?
    
    var ask : View = {
        var v = View(secondaries: true)
        v.backgroundColor = colors.loginTfBack
        return v
    }()
    
    var askLabel : Label?
    
    var confirm : ActionButton?
    
    var neverMind : ActionButton?
    
    private var fields : [UIView] = []
    
    convenience init<T:UIViewController, T1: UIViewController>(loadPosition: ModalViewControllerLayoutOptions, delegate: T?, contactDelegate: T1?, currentContact: Contact, at: IndexPath) where T: ModalViewControllerPanningDelegate, T1: EditContactUserResponseDelegate  {
        self.init(backgroundColor: colors.loginTfBack, loadPosition: loadPosition)
        self.delegate = delegate
        self.userDelegate = contactDelegate
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.currentContact = currentContact
        self.editingContact = EditContactNode(original: currentContact)
        self.currentIndex = at
        fields = [email.field, name.field, last.field, company.field, job.field, email.field, dob.field, Phone.field, postalcode.field, pic]
        for f in fields {
            f.isUserInteractionEnabled = false
        }
        inputDelegate = self
    }
    
    private func parseContact(_ cont: Contact) {
        name.field.text = cont.name
        last.field.text = cont.lastName
        company.field.text = cont.company.isEmpty ? nil : cont.company
        job.field.text = cont.jobTitle.isEmpty ? nil : cont.jobTitle
        postalcode.field.text = cont.postalCode
        email.field.text = cont.email
        if let p = cont.phone {
            phoneText = p
            Phone.field.text = p.symbolized
            phoneValue = p.compact
        }
        if let da = cont.dob {
            d = da.year.string + da.month.string + da.day.string
            if !d.isEmpty {
                do {
                    let inter = try DateExpression(date: d)
                    dobValue = inter
                    dob.field.text = inter.YMDDashed
                } catch {
                    print("No Failed to apply DOB from : \(d)")
                }
            } else {
                dob.field.text = nil
            }
        } else {
            dob.field.text = nil
        }
        if let url = cont.picUrl {
            pic.loadFrom(urlString: url)
        }
    }
    
    override func set() {
        super.set()
        
        
        label.textColor = UIColor.clear
    }
    
    override func subclassAnimationsOnAppear() {
        if let t = self.currentContact {
            parseContact(t)
        }
        UIView.animate(withDuration: 0.35, delay: 0.3, options: .curveEaseIn, animations: {
            self.deleteContact.alpha = 1
        }) { (v) in
            
        }
    }
    
    override func subclassConstraints() {
        
        view.addSubview(deleteContact)
        
        new.addSubview(edit)
        new.addSubview(cancelEdit)
        
        deleteContact.block.bottomConstraint = deleteContact.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
        deleteContact.block.heightConstraint = deleteContact.heightAnchor.constraint(equalToConstant: buttonSizes.mainheight * 1.1)
        deleteContact.block.leftConstraint = deleteContact.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18)
        deleteContact.block.rightConstraint = deleteContact.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        
        edit.width(new, .width, ConstraintVariables(.width, buttonSizes.mainheight * 2).fixConstant(), nil)
        edit.height(new, .height, ConstraintVariables(.width, buttonSizes.mainheight).fixConstant(), nil)
        edit.top(new, .top, ConstraintVariables(.top, 10).fixConstant(), nil)
        edit.right(new, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        edit.delegate = self
        
        cancelEdit.width(new, .width, ConstraintVariables(.width, buttonSizes.mainheight * 2).fixConstant(), nil)
        cancelEdit.height(new, .height, ConstraintVariables(.width, buttonSizes.mainheight).fixConstant(), nil)
        cancelEdit.top(new, .top, ConstraintVariables(.top, 10).fixConstant(), nil)
        cancelEdit.right(new, .right, ConstraintVariables(.right, -10).fixConstant(), nil)
        cancelEdit.delegate = self
        
    }
    
    override func subclassActivators() {
        
        deleteContact.activateConstraints()
        edit.activateConstraints()
        cancelEdit.activateConstraints()
        
    }
    
    override func subclassDelegates() {
        super.subclassDelegates()
        
        deleteContact.delegate = self
        edit.delegate = self
        cancelEdit.delegate = self
    }
    
    override func subclassProperties() {
        super.subclassProperties()
        
        let getPic = UITapGestureRecognizer()
        getPic.addTarget(self, action: #selector(getPicture))
        pic.addGestureRecognizer(getPic)
        
        addLayers(to: deleteContact)
        
        addLayersRelative(to: cancelEdit)
    }
    
    func addLayersRelative(to: ActionButton) {
        to.actionType = .null
        if let height = to.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: height.constant * 2, height: height.constant), cornerRadius: 5).cgPath
            to.layer.shadowPath = path
            to.layer.shadowRadius = 6.0
            to.layer.shadowOffset = CGSize(width: 0, height: 6)
            to.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            to.layer.shadowOpacity = 0.5
            to.layer.cornerRadius = 5
        }
    }
    
    func addLayersRelativeConstraints(to: ActionButton) {
        to.actionType = .null
        to.layoutIfNeeded()
        if let height = to.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: to.frame.width, height: height.constant), cornerRadius: 5).cgPath
            to.layer.shadowPath = path
            to.layer.shadowRadius = 6.0
            to.layer.shadowOffset = CGSize(width: 0, height: 6)
            to.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            to.layer.shadowOpacity = 0.5
            to.layer.cornerRadius = 5
        }
    }
    
    var mainButtonAction : (()->())?
    
    var dontBlockTransform : Bool = true
    
    func transformDeleteToEdit() {
        guard dontBlockTransform else { return }
        dontBlockTransform = false
        UIView.animate(withDuration: 0.35, animations: {
            self.deleteContact.setTitle("Save", for: .normal)
            self.deleteContact.backgroundColor = colors.purplishColor//UIColor.rgb(red: 0, green: 128, blue: 255)
            self.deleteContact.untouchedColor = colors.purplishColor//UIColor.rgb(red: 0, green: 128, blue: 255)
            self.deleteContact.touchedColor = colors.darkPurplishColor//colors.purplishColor
            self.edit.alpha = 0
            self.cancelEdit.alpha = 1
        }) { (v) in
            self.currentlyEditing = true
            self.dontBlockTransform = true
        }
        for f in fields {
            f.isUserInteractionEnabled = true
        }
    }
    
    func reApplyOldContactToView() {
        guard let current = currentContact else {
            return
        }
        editingContact?.new = nil
        editingContact?.original = current
        parseContact(current)
    }
    
    func transformEditToDelete() {
        guard dontBlockTransform else { return }
        dontBlockTransform = false
        reApplyOldContactToView()
        UIView.animate(withDuration: 0.35, animations: {
            self.deleteContact.setTitle("Delete", for: .normal)
            self.deleteContact.backgroundColor = SpotitColors.errorColors.responseRed
            self.deleteContact.untouchedColor = SpotitColors.errorColors.responseRed
            self.deleteContact.touchedColor = SpotitColors.errorColors.responseRedDarker
            self.edit.alpha = 1
            self.cancelEdit.alpha = 0
        }) { (v) in
            self.currentlyEditing = false
            self.dontBlockTransform = true
        }
        for f in fields {
            f.isUserInteractionEnabled = false
        }
        tapDismiss()
    }
    
    func hideRequestView() {
        askLabel?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.ask.frame.size = CGSize(width: 0, height: 0)
            self.ask.center.x = self.view.frame.width / 2
            self.ask.center.y = self.view.frame.height / 2
            self.opaqueView?.alpha = 0
            self.ask.layoutIfNeeded()
            self.addLayersRelativeConstraints(to: self.confirm!)
            self.addLayersRelativeConstraints(to: self.neverMind!)
            self.layerToViewBySize(self.ask)
        }) { (v) in
            self.confirm?.removeFromSuperview()
            self.neverMind?.removeFromSuperview()
            self.askLabel?.removeFromSuperview()
            self.ask.removeFromSuperview()
            self.opaqueView?.removeFromSuperview()
            self.neverMind = nil
            self.confirm = nil
            self.askLabel = nil
            self.opaqueView = nil
        }
    }
    
    func hideRequestView(_ completion: (()->())?) {
        askLabel?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.ask.frame.size = CGSize(width: 0, height: 0)
            self.ask.center.x = self.view.frame.width / 2
            self.ask.center.y = self.view.frame.height / 2
            self.opaqueView?.alpha = 0
            self.ask.layoutIfNeeded()
            self.addLayersRelativeConstraints(to: self.confirm!)
            self.addLayersRelativeConstraints(to: self.neverMind!)
            self.layerToViewBySize(self.ask)
        }) { (v) in
            self.confirm?.removeFromSuperview()
            self.neverMind?.removeFromSuperview()
            self.askLabel?.removeFromSuperview()
            self.ask.removeFromSuperview()
            self.opaqueView?.removeFromSuperview()
            self.neverMind = nil
            self.confirm = nil
            self.askLabel = nil
            self.opaqueView = nil
            completion?()
        }
    }
    
    func closeFromDelete(_ completion: (()->Void)?) {
        self.hideRequestView()
        self.dismiss(animated: true, completion: completion)
    }
    
    func header(button: ActionButton, wasPressed info: Any?) {
        if button == deleteContact {
            parseAction()
        }
        if button == confirm {
            removeContact({
                DispatchQueue.main.async {
                    if let d = self.delegate  {
                        d.modal(viewController: self, dismissed: true, with: 1.0)
                    }
                }
            })
        }
        if button == neverMind {
            hideRequestView()
        }
        if button == edit {
            transformDeleteToEdit()
        }
        if button == cancelEdit {
            transformEditToDelete()
        }
    }
    
    func contact(controller: ContactController, didEmit: String, with: String, by: ContactParameter) {
        if controller == self {
            removeErrorBased(by)
            if with.isEmpty {
                editingContact?.update(by, didEmit)
            } else {
                editingContact?.update(by, didEmit+with)
            }
        }
    }
    
    func removeErrorBased(_ by: ContactParameter) {
        switch by {
        case .corp:
            removeError(company)
        case .name:
            removeError(name)
        case .last:
            removeError(last)
        case .title:
            removeError(job)
        case .email:
            removeError(email)
        case .dob:
            removeError(dob)
        case .phone:
            removeError(Phone)
        case .zip:
            removeError(postalcode)
        default:
            break
        }
    }
    
    func parseAction() {
        guard currentlyEditing else {
            askToRemove()
            return
        }
        saveNewInfo()
    }

    func askToRemove() {
        
        opaqueView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        opaqueView?.alpha = 0
        opaqueView?.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.addSubview(opaqueView!)
        opaqueView?.addSubview(ask)
        
        ask.frame.size = CGSize(width: 0, height: 0)
        ask.center.x = view.frame.width / 2
        ask.center.y = view.frame.height / 2
        
        askLabel = Label(secondaries: true)
        ask.addSubview(askLabel!)
        askLabel?.text = "Are you sure that you want to delete \(currentContact!.name) from your contacts?"
        askLabel?.textColor = colors.lineColor.withAlphaComponent(0.9)
        askLabel?.textAlignment = .center
        askLabel?.numberOfLines = 0
        askLabel?.font = GlobalFonts.controllerTitle
        askLabel?.alpha = 0
        
        askLabel?.left(ask, .left, ConstraintVariables(.left, 8).fixConstant(), nil)
        askLabel?.top(ask, .top, ConstraintVariables(.top, 0).fixConstant(), nil)
        askLabel?.height(ask, .height, ConstraintVariables(.height, 0).m(0.5), nil)
        askLabel?.right(ask, .right, ConstraintVariables(.right, -4).fixConstant(), nil)
        
        confirm = ActionButton(secondaries: true)
        ask.addSubview(confirm!)
        confirm?.setTitle("Yes", for: .normal)
        confirm?.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        confirm?.touchedColor = colors.purplishColor
        confirm?.alpha = 1
        
        confirm?.left(ask, .left, ConstraintVariables(.left, 8).fixConstant(), nil)
        confirm?.height(ask, .width, ConstraintVariables(.width, buttonSizes.mainheight).fixConstant(), nil)
        confirm?.bottom(ask, .bottom, ConstraintVariables(.bottom, -8).fixConstant(), nil)
        confirm?.right(ask, .horizontal, ConstraintVariables(.right, -4).fixConstant(), nil)
        
        neverMind = ActionButton(secondaries: true)
        ask.addSubview(neverMind!)
        neverMind?.setTitle("No", for: .normal)
        neverMind?.untouchedColor = UIColor.rgb(red: 0, green: 128, blue: 255)
        neverMind?.touchedColor = colors.purplishColor
        neverMind?.alpha = 1
        
        neverMind?.left(ask, .horizontal, ConstraintVariables(.left, 4).fixConstant(), nil)
        neverMind?.height(ask, .width, ConstraintVariables(.width, buttonSizes.mainheight).fixConstant(), nil)
        neverMind?.bottom(ask, .bottom, ConstraintVariables(.bottom, -8).fixConstant(), nil)
        neverMind?.right(ask, .right, ConstraintVariables(.right, -8).fixConstant(), nil)
        confirm?.delegate = self
        neverMind?.delegate = self
        
        self.askLabel?.activateConstraints()
        self.confirm?.activateConstraints()
        self.neverMind?.activateConstraints()
        self.ask.layer.cornerRadius = 10
        
        let size = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.width * 0.6)
        let dim = buttonSizes.mainheight * 1.2
        
        addProgressIndicator(ask, withSize: size, CGSize(width: dim, height: dim), ColorGradient(colors: colors.purplishColor.withAlphaComponent(0.0), colors.purplishColor))
        
        UIView.animate(withDuration: 0.35, animations: {
            self.ask.frame.size = size
            self.ask.center.x = self.view.frame.width / 2
            self.ask.center.y = self.view.frame.height / 2
            self.opaqueView?.alpha = 1
            self.ask.layoutIfNeeded()
        }) { (v) in
            self.addLayersRelativeConstraints(to: self.confirm!)
            self.addLayersRelativeConstraints(to: self.neverMind!)
            self.layerToViewBySize(self.ask)
            UIView.animate(withDuration: 0.3, animations: {
                self.askLabel?.alpha = 1
            })
        }
        
    }
    
    func layerToView(_ v: View) {
        if let height = v.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: new.frame.width - (18 * 2), height: height.constant), cornerRadius: 5).cgPath
            v.layer.shadowPath = path
            v.layer.shadowRadius = 6.0
            v.layer.shadowOffset = CGSize(width: 0, height: 6)
            v.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            v.layer.shadowOpacity = 0.5
            v.layer.cornerRadius = 5
        }
    }
    
    func layerToViewBySize(_ v: View) {
        if let height = v.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: v.frame.size.width, height: height.constant), cornerRadius: v.layer.cornerRadius).cgPath
            v.layer.shadowPath = path
            v.layer.shadowRadius = 6.0
            v.layer.shadowOffset = CGSize(width: 0, height: 6)
            v.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            v.layer.shadowOpacity = 0.5
            v.layer.cornerRadius = v.layer.cornerRadius
        }
    }
    
    func saveNewInfo() {
        guard let n = name.field.text, !n.isEmpty else {
            displayError(name, "Please Provide a Name")
            return
        }
        let size = CGSize(width: deleteContact.frame.height * 0.9, height: deleteContact.frame.height * 0.9)
        deleteContact.titleLabel?.alpha = 0
        addProgressIndicator(deleteContact, withSize: deleteContact.frame.size, size, ColorGradient(colors: UIColor.white.withAlphaComponent(0.0), UIColor.white))
        deleteProgress?.lay.animateCircleTo(duration: 0.4, toValue: 1.0)
        if let edit = editingContact, let verified = captureVisibleInfo(self.currentContact!) {
            edit.new = verified
            if let it = edit.resulting() {
                update(it, edit.newPicString(), { (err) in
                    if let e = err {
                        print(e, "Error editing contact")
                    } else {
                        self.currentContact = it
                        DispatchQueue.main.async {
                            self.stopRotatingView(self.deleteContact, nil)
                            self.transformEditToDelete()
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self.stopRotatingView(self.deleteContact, nil)
                }
                self.transformEditToDelete()
            }
        }
    }
    
    func update(_ new: Contact,_ newPic: Bool,_ completion: ((String?)->())?) {
        if let d = self.userDelegate, let ind = currentIndex, let ori = currentContact {
            if newPic {
                FirebaseManager.node.update(new, pic.image, newImage: true, { (newContact) in
                    guard let t = newContact else {
                        completion?("Failed to update Firebase with new Image")
                        return
                    }
                    self.editingContact?.update(.pic, "")
                    ContactsCD.node.update(t, {
                        d.edit(user: self, didEdit: t, at: ind)
                        completion?(nil)
                    })
                })
            } else {
                FirebaseManager.node.updateValue(new.id, new.object, {
                    ContactsCD.node.update(new, {
                        d.edit(user: self, didEdit: new, at: ind)
                        completion?(nil)
                    })
                })
            }
        } else {
            completion?("Failed to update : no delegate, index, or contact")
        }
    }
    
    
    func captureVisibleInfo(_ this: Contact) -> Contact? {
        guard let n = name.field.text, !n.isEmpty else {
            displayError(name, "Please Provide a Name")
            return nil
        }
        let contact = Contact()
        contact.id = this.id
        contact.name = n
        contact.picID = this.picID
        if let t = last.field.text, t.characters.count > 0 {
            contact.lastName = t
        }
        if let t = email.field.text, t.characters.count > 0 {
            guard t.characters.count >= 8 else {
                displayError(email, nil)
                return nil
            }
            contact.email = t
        }
        if let t = dobText, d.characters.count > 0 {
            guard d.characters.count == 8 else {
                displayError(dob, nil)
                return nil
            }
            contact.dob = t
        }
        if let t = phoneText, t.value.characters.count > 0 {
            guard phoneValue.characters.count == 10 else {
                displayError(postalcode, nil)
                return nil
            }
            contact.phone = t
        }
        if let t = postalcode.field.text, t.characters.count > 0 {
            guard t.characters.count == 6 else {
                displayError(postalcode, nil)
                return nil
            }
            contact.postalCode = t
        }
        if let t = company.field.text, t.characters.count > 0  {
            guard t.characters.count > 2 else {
                displayError(company, nil)
                return nil
            }
            contact.company = t
        }
        if let t = job.field.text, t.characters.count > 0 {
            contact.jobTitle = t
        }
        if picChanged {
            contact.picUrl == "new"
        } else {
            contact.picUrl = this.picUrl
        }
        return contact
    }
    
    func removeContact(_ completion: (()->())?) {
        if let d = self.userDelegate, let c = currentContact, let i = currentIndex {
            d.edit(user: self, didDelete: c, at: i)
            ContactsCD.node.delete(c, {
                FirebaseManager.node.delete(c, { (err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "Some Error Occured While Deleting Contact")
                    } else{
                        completion?()
                    }
                })
            })
        }
        
    }
    
    
}
