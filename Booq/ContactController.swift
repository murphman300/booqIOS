//
//  ContactController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase


protocol ContactControllerInputDelegate {
    func contact(controller: ContactController, didEmit: String, with: String, by: ContactParameter)
}

class ContactController: ModalViewController, UITextFieldDelegate, GradientLoaderDelegate {
    
    var captureView : CameraPictureCaptureView?
    
    var phoneText : PhoneNumber?
    
    var dobText : DOB?
    
    var dobValue : DateExpression?
    
    var inputDelegate : ContactControllerInputDelegate?
    
    var picChanged : Bool = false
    
    var top : View = {
        var v = View(secondaries: true)
        v.alpha = 1
        v.backgroundColor = .white
        return v
    }()
    
    
    var contact = Contact()
    
    var topTransitionView : View = {
        var v = View(secondaries: true)
        v.alpha = 0
        return v
    }()
    
    var label : Label = {
        var v = Label(secondaries: true)
        v.numberOfLines = 0
        v.textColor = colors.purplishColor.withAlphaComponent(0.95)
        v.font = GlobalFonts.controllerTitle
        v.textAlignment = .center
        return v
    }()
    
    var pic : LocalizedImageView = {
        var p = LocalizedImageView(cornerRadius: 0.0)
        p.backgroundColor = UIColor.clear
        p.contentMode = .scaleAspectFit
        return p
    }()
    
    var name : ListingContainer = {
        let comb = TextFieldCombination(holder: "First Name")
        var v = ListingContainer(title: "", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 8, input: 10))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var last : ListingContainer = {
        let comb = TextFieldCombination(holder: "Last Name")
        var v = ListingContainer(title: "", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 8, input: 10))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var dob : ListingContainer = {
        let comb = TextFieldCombination(holder: "YYYY - MM - DD")
        var v = ListingContainer(title: "Birthday", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 18, input: 18))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var email : ListingContainer = {
        let comb = TextFieldCombination(holder: "email@abc.com")
        var v = ListingContainer(title: "Email", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 18, input: 18))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var Phone : ListingContainer = {
        let comb = TextFieldCombination(holder: "(123) 456 7890")
        var v = ListingContainer(title: "Phone", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 18, input: 18))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var postalcode : ListingContainer = {
        let comb = TextFieldCombination(holder: "A1B 2C3")
        var v = ListingContainer(title: "Zip Code", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 18, input: 18))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var job : ListingContainer = {
        let comb = TextFieldCombination(holder: "CEO/Analyst/...")
        var v = ListingContainer(title: "Job Title", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 18, input: 18))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var company : ListingContainer = {
        let comb = TextFieldCombination(holder: "A Company")
        var v = ListingContainer(title: "Company", inputs: comb, inline: true, paddingScheme: PaddingScheme(title: 18, input: 18))
        v.listingTint = colors.purplishColor.withAlphaComponent(0.9)
        return v
    }()
    
    var content : ScrollView = {
        var v = ScrollView(secondaries: true)
        v.isUserInteractionEnabled = true
        v.isScrollEnabled = true
        return v
    }()
    
    var container : UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    var listingHeight : CGFloat {
        return buttonSizes.mainheight * 1.8
    }
    
    
    let topPerc : CGFloat = 0.4
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subclassAnimationsOnAppear()
    }
    
    func subclassAnimationsOnAppear() {
        
    }
    
    override func set() {
        super.set()
        
        backColor = 0.8
        
        new.backgroundColor = colors.loginTfBack
        
        new.addSubview(content)
        content.addSubview(container)
        container.addSubview(top)
        top.addSubview(label)
        top.addSubview(pic)
        top.addSubview(name)
        top.addSubview(last)
        container.addSubview(dob)
        container.addSubview(email)
        container.addSubview(Phone)
        container.addSubview(postalcode)
        container.addSubview(job)
        container.addSubview(company)
        
        
        name.field.delegate = self
        name.field.resignTo = last.field
        last.field.delegate = self
        last.field.resignTo = company.field
        
        company.field.delegate = self
        company.field.resignTo = job.field
        job.field.delegate = self
        job.field.resignTo = email.field
        email.field.delegate = self
        email.field.resignTo = dob.field
        dob.field.delegate = self
        dob.field.resignTo = Phone.field
        Phone.field.delegate = self
        Phone.field.resignTo = postalcode.field
        postalcode.field.delegate = self
        
        subclassDelegates()
        
        version1()
        
        subclassConstraints()
        
        pic.block.vertical = pic.centerYAnchor.constraint(equalTo: top.centerYAnchor, constant: 25)
        pic.block.rightConstraint = pic.leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: 18)
        pic.block.heightConstraint = pic.heightAnchor.constraint(equalTo: top.heightAnchor, multiplier: 0.6)
        pic.block.widthConstraint = pic.widthAnchor.constraint(equalTo: top.heightAnchor, multiplier: 0.6)
        pic.layer.cornerRadius = view.frame.width * topPerc * 0.6 * 0.5
        pic.layer.masksToBounds = true
        
        name.block.topConstraint = name.topAnchor.constraint(equalTo: pic.topAnchor, constant: 0)
        name.block.heightConstraint = name.heightAnchor.constraint(equalTo: pic.heightAnchor, multiplier: 0.5)
        name.block.leftConstraint = name.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: -10)
        name.block.rightConstraint = name.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 18)
        
        last.block.topConstraint = last.bottomAnchor.constraint(equalTo: pic.bottomAnchor, constant: 0)
        last.block.heightConstraint = last.heightAnchor.constraint(equalTo: pic.heightAnchor, multiplier: 0.5)
        last.block.leftConstraint = last.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: -10)
        last.block.rightConstraint = last.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 18)
        
        label.block.topConstraint = label.topAnchor.constraint(equalTo: top.topAnchor, constant: 0)
        label.block.bottomConstraint = label.bottomAnchor.constraint(equalTo: pic.topAnchor, constant: -10)
        label.block.leftConstraint = label.leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: 0)
        label.block.rightConstraint = label.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: 0)
        
        content.top(new, .top, ConstraintVariables(.top, 0).fixConstant(), nil)
        content.left(new, .left, ConstraintVariables(.left, 0).fixConstant(), nil)
        content.right(new, .right, ConstraintVariables(.right, 0).fixConstant(), nil)
        content.bottom(new, .bottom, ConstraintVariables(.bottom, 0).fixConstant(), nil)
        
        content.activateConstraints()
        
        container.frame = CGRect(x: 0, y: 0, width: new.frame.width, height: new.frame.height - 20)
        content.contentSize = CGSize(width: container.frame.width, height: self.view.frame.height - 40)
        
        top.activateConstraints()
        pic.activateConstraints()
        label.activateConstraints()
        name.activateConstraints()
        last.activateConstraints()
        company.activateConstraints()
        job.activateConstraints()
        email.activateConstraints()
        dob.activateConstraints()
        Phone.activateConstraints()
        postalcode.activateConstraints()
        
        subclassActivators()
        
        name.makeBottom()
        last.makeBottom()
        company.makeBottom()
        job.makeBottom()
        email.makeBottom()
        dob.makeBottom()
        Phone.makeBottom()
        postalcode.makeBottom()
        reApplyRemovedObservers()
        
        
        let dismiss = UITapGestureRecognizer()
        dismiss.addTarget(self, action: #selector(tapDismiss))
        new.addGestureRecognizer(dismiss)
        

        Phone.keyBoard = UIKeyboardType.numberPad
        addDoneButtonTo(Phone.field)
        email.keyBoard = UIKeyboardType.emailAddress
        dob.keyBoard = UIKeyboardType.numberPad
        addDoneButtonTo(dob.field)
        
        subclassProperties()
    }
    
    func subclassDelegates() {
        
    }
    
    func subclassConstraints() {
        
        
    }
    
    func subclassActivators() {
        
    }
    
    func subclassPostAnimators() {
        
    }
    
    func subclassProperties() {
        
    }
    
    var buttoned : [TextField] = []
    
    func addDoneButtonTo(_ textField: TextField) {
        let toolbarDone = UIToolbar.init()
        toolbarDone.backgroundColor = new.backgroundColor
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem()
        barBtnDone.title = "Next"
        barBtnDone.action = #selector(sumFunc)
        barBtnDone.tintColor = colors.purplishColor
        barBtnDone.style = .done
        toolbarDone.items = [barBtnDone]
        textField.inputAccessoryView = toolbarDone
        buttoned.append(textField)
    }
    
    @objc func sumFunc() {
        for b in buttoned {
            if b.isFirstResponder, let next = b.resignTo {
                next.becomeFirstResponder()
            }
        }
    }
    
    func version1() {
        top.block.topConstraint = top.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        top.block.leftConstraint = top.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        top.block.rightConstraint = top.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        top.block.heightConstraint = top.heightAnchor.constraint(equalTo: container.widthAnchor, multiplier: topPerc)
        
        company.block.topConstraint = company.topAnchor.constraint(equalTo: top.bottomAnchor, constant: 25)
        company.block.heightConstraint = company.heightAnchor.constraint(equalToConstant: listingHeight * 0.8)
        company.block.leftConstraint = company.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        company.block.rightConstraint = company.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        job.block.topConstraint = job.topAnchor.constraint(equalTo: company.bottomAnchor, constant: 0)
        job.block.heightConstraint = job.heightAnchor.constraint(equalToConstant: listingHeight * 0.8)
        job.block.leftConstraint = job.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        job.block.rightConstraint = job.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        email.block.topConstraint = email.topAnchor.constraint(equalTo: job.bottomAnchor, constant: 0)
        email.block.heightConstraint = email.heightAnchor.constraint(equalToConstant: listingHeight * 0.8)
        email.block.leftConstraint = email.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        email.block.rightConstraint = email.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        dob.block.topConstraint = dob.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 0)
        dob.block.heightConstraint = dob.heightAnchor.constraint(equalToConstant: listingHeight * 0.8)
        dob.block.leftConstraint = dob.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        dob.block.rightConstraint = dob.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        Phone.block.topConstraint = Phone.topAnchor.constraint(equalTo: dob.bottomAnchor, constant: 0)
        Phone.block.heightConstraint = Phone.heightAnchor.constraint(equalToConstant: listingHeight * 0.8)
        Phone.block.leftConstraint = Phone.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        Phone.block.rightConstraint = Phone.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        postalcode.block.topConstraint = postalcode.topAnchor.constraint(equalTo: Phone.bottomAnchor, constant: 0)
        postalcode.block.heightConstraint = postalcode.heightAnchor.constraint(equalToConstant: listingHeight * 0.8)
        postalcode.block.leftConstraint = postalcode.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        postalcode.block.rightConstraint = postalcode.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        
        
    }
    
    func version2() {
        top.block.topConstraint = top.topAnchor.constraint(equalTo: new.topAnchor, constant: 0)
        top.block.leftConstraint = top.trailingAnchor.constraint(equalTo: new.trailingAnchor, constant: 0)
        top.block.rightConstraint = top.leadingAnchor.constraint(equalTo: new.leadingAnchor, constant: 0)
        top.block.heightConstraint = top.heightAnchor.constraint(equalTo: new.widthAnchor, multiplier: 0.6)
        
        dob.block.topConstraint = dob.topAnchor.constraint(equalTo: top.bottomAnchor, constant: 10)
        dob.block.heightConstraint = dob.heightAnchor.constraint(equalToConstant: listingHeight)
        dob.block.leftConstraint = dob.trailingAnchor.constraint(equalTo: new.trailingAnchor, constant: 0)
        dob.block.rightConstraint = dob.leadingAnchor.constraint(equalTo: new.leadingAnchor, constant: 0)
        
        email.block.topConstraint = email.topAnchor.constraint(equalTo: dob.bottomAnchor, constant: 10)
        email.block.heightConstraint = email.heightAnchor.constraint(equalToConstant: listingHeight)
        email.block.leftConstraint = email.trailingAnchor.constraint(equalTo: new.trailingAnchor, constant: 0)
        email.block.rightConstraint = email.leadingAnchor.constraint(equalTo: new.leadingAnchor, constant: 0)
        
        Phone.block.topConstraint = Phone.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10)
        Phone.block.heightConstraint = Phone.heightAnchor.constraint(equalToConstant: listingHeight)
        Phone.block.leftConstraint = Phone.trailingAnchor.constraint(equalTo: new.trailingAnchor, constant: 0)
        Phone.block.rightConstraint = Phone.leadingAnchor.constraint(equalTo: new.leadingAnchor, constant: 0)
        
        postalcode.block.topConstraint = postalcode.topAnchor.constraint(equalTo: Phone.bottomAnchor, constant: 10)
        postalcode.block.heightConstraint = postalcode.heightAnchor.constraint(equalToConstant: buttonSizes.mainheight * 1.1)
        postalcode.block.leftConstraint = postalcode.trailingAnchor.constraint(equalTo: new.trailingAnchor, constant: 0)
        postalcode.block.rightConstraint = postalcode.leadingAnchor.constraint(equalTo: new.leadingAnchor, constant: 0)
    }
    
    func addLayers(to: ActionButton) {
        to.actionType = .null
        if let height = to.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: new.frame.width - (18 * 2), height: height.constant), cornerRadius: 5).cgPath
            to.layer.shadowPath = path
            to.layer.shadowRadius = 6.0
            to.layer.shadowOffset = CGSize(width: 0, height: 6)
            to.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            to.layer.shadowOpacity = 0.5
            to.layer.cornerRadius = 5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let field = textField as? TextField else { return true }
        if let next = field.resignTo {
            
            if next.isHidden && panBlocker {
                if next == name || next == last {
                    content.scrollRectToVisible(CGRect(x: 0, y: 0, width: content.frame.width, height: content.frame.height), animated: true)
                } else if next == name || next == name || next == name || next == name {
                    content.scrollRectToVisible(CGRect(x: 0, y: content.contentSize.height - content.frame.height, width: content.frame.width, height: content.frame.height), animated: true)
                }
            }
            next.becomeFirstResponder()
            return false
        }
        field.resignFirstResponder()
        return true
    }
    
    var phoneValue = String()
    var d = String()
    
    func applyInput(tf: TextField, current: String, with: String, element: ContactParameter) {
        if let d = self.inputDelegate {
            d.contact(controller: self, didEmit: current, with: with, by: element)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == name.field {
            if let t = textField.text, t == "Please Provide a Name" {
                removeError(name)
                textField.text = string.capitalized
                applyInput(tf: name.field, current: "", with: string, element: .name)
                return false
            } else {
                if let text = textField.text, string.isEmpty {
                    var t = text
                    _ = t.characters.popLast()
                    applyInput(tf: name.field, current: t, with: "", element: .name)
                }
                return true
            }
        } else if textField == last.field {
            if let text = textField.text, !string.isEmpty {
                textField.text = (text + string).capitalized
                applyInput(tf: last.field, current: text, with: string, element: .last)
                return false
            } else {
                if let text = textField.text, string.isEmpty {
                    var t = text
                    _ = t.characters.popLast()
                    applyInput(tf: company.field, current: t, with: "", element: .last)
                }
                return true
            }
        } else if textField == company.field {
            if let text = textField.text, !string.isEmpty {
                textField.text = (text + string).capitalized
                applyInput(tf: last.field, current: text, with: string, element: .corp)
                return false
            } else {
                if let text = textField.text, string.isEmpty {
                    var t = text
                    _ = t.characters.popLast()
                    applyInput(tf: company.field, current: t, with: "", element: .corp)
                }
                return true
            }
        } else if textField == email.field {
            if let text = textField.text, !string.isEmpty {
                let it = (text + string).lowercased()
                textField.text = it
                applyInput(tf: email.field, current: text, with: string, element: .email)
                return false
            } else {
                if let text = textField.text, string.isEmpty {
                    var t = text
                    _ = t.characters.popLast()
                    applyInput(tf: postalcode.field, current: t, with: "", element: .email)
                }
            }
        } else if textField == postalcode.field {
            if let text = textField.text, !string.isEmpty {
                textField.text = (text + string).uppercased()
                applyInput(tf: postalcode.field, current: text, with: string, element: .zip)
                return false
            } else {
                if let text = textField.text, string.isEmpty {
                    var t = text
                    _ = t.characters.popLast()
                    applyInput(tf: postalcode.field, current: t, with: "", element: .zip)
                }
            }
        } else if textField == Phone.field {
            guard phoneValue.characters.count < 10 || (phoneValue.characters.count == 10 && string.isEmpty) else { return false }
            removeError(Phone)
            if textField.text != nil, !string.isEmpty {
                do {
                    applyInput(tf: Phone.field, current: phoneValue, with: string, element: .phone)
                    phoneValue = phoneValue + string
                    phoneText = try PhoneNumber(number: phoneValue)
                    if let p = phoneText {
                        textField.text = p.symbolized
                    }
                    if phoneValue.characters.count < 10 {
                        phoneText = nil
                    }
                    return false
                } catch {
                    phoneText = nil
                    return true
                }
            } else if textField.text != nil {
                do {
                    _ = phoneValue.characters.popLast()
                    phoneText = try PhoneNumber(number: phoneValue)
                    if let p = phoneText {
                        applyInput(tf: Phone.field, current: phoneValue, with: "", element: .phone)
                        textField.text = p.symbolized
                    }
                    if phoneValue.characters.count < 10 {
                        phoneText = nil
                    }
                } catch {
                    phoneText = nil
                    return true
                }
            }
            if string.isEmpty {
                if phoneValue.characters.count < 10 {
                    phoneText = nil
                }
                return false
            } else {
                return false
            }
        } else if textField == dob.field {
            guard d.characters.count < 8 || (d.characters.count == 8 && string.isEmpty) else { return false }
            guard textField.text != nil else { return false }
            removeError(dob)
            if textField.text != nil, !string.isEmpty {
                do {
                    d = d + string
                    dobValue = try DateExpression(date: d)
                    if let p = dobValue {
                        applyInput(tf: dob.field, current: d, with: "", element: .dob)
                        textField.text = p.YMDDashed
                        if let date = p.dob {
                            dobText = date
                        }
                    }
                    return false
                } catch {
                    dobValue = nil
                    return true
                }
            } else if textField.text != nil {
                do {
                    _ = d.characters.popLast()
                    dobValue = try DateExpression(date: d)
                    if let p = dobValue {
                        applyInput(tf: dob.field, current: d, with: "", element: .dob)
                        textField.text = p.YMDDashed
                        if let date = p.dob {
                            dobText = date
                        }
                    }
                } catch {
                    dobValue = nil
                    return true
                }
            }
            if string.isEmpty {
                if d.characters.count < 8 {
                    dobValue = nil
                    dobText = nil
                }
                return false
            } else {
                return false
            }
        }
        guard let text = textField.text else {
            if textField == job.field {
                applyInput(tf: job.field, current: "", with: string, element: .title)
            }
            if textField == company.field {
                applyInput(tf: company.field, current: "", with: string, element: .corp)
            }
            return true
        }
        if string.isEmpty {
            var t = text
            _ = t.characters.popLast()
            if textField == job.field {
                applyInput(tf: job.field, current: t, with: "", element: .title)
            }
            if textField == company.field {
                applyInput(tf: company.field, current: text, with: "", element: .corp)
            }
        } else {
            if textField == job.field {
                applyInput(tf: job.field, current: text, with: string, element: .title)
            }
            if textField == company.field {
                applyInput(tf: company.field, current: text, with: string, element: .corp)
            }
        }
        return true
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func reApplyRemovedObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(searchDisplace(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchReplace), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var prevH : CGFloat = 0
    
    var tap = UITapGestureRecognizer()
    
    func searchDisplace(notification: Notification) {
        guard !panBlocker else { return }
        panBlocker = true
        guard let userInfo:NSDictionary = notification.userInfo as NSDictionary? else { return }
        guard let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue else { return }
        tap.addTarget(self, action: #selector(tapDismiss))
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let keybheight = keyboardHeight
        prevH = new.frame.height
        UIView.animate(withDuration: 0.5, animations: {
            self.new.center.y = self.actualCenter - self.topDifference!
            self.new.frame.size.height = (self.view.frame.height * 0.6) - 20 //- //30 - keybheight
            self.new.layer.cornerRadius = 10
            self.container.frame = CGRect(x: 0, y: 0, width: self.new.frame.width, height: self.view.frame.height - 40)
            self.content.contentSize = CGSize(width: self.new.frame.width, height: self.view.frame.height - buttonSizes.mainheight * 1.1)
            self.new.layoutIfNeeded()
        }) { (v) in
            self.content.contentSize = CGSize(width: self.new.frame.width, height: self.view.frame.height - 40)
            self.content.isScrollEnabled = true
            self.content.isUserInteractionEnabled = true
        }
    }
    
    func searchReplace() {
        panBlocker = false
        UIView.animate(withDuration: 0.35) {
            self.new.center.y = self.actualCenter
            self.new.frame.size.height = self.view.frame.height - 20 - (self.topDifference != nil ? self.topDifference! : 0) - (self.bottomDifference != nil ? self.bottomDifference! : 0)
            self.content.contentSize = CGSize(width: self.new.frame.width, height: self.view.frame.height - 40)
            self.parseCorners()
            self.new.layoutIfNeeded()
        }
        self.content.contentSize = CGSize(width: new.frame.width, height: self.container.frame.height)
    }
    
    private var originalTextColor = UIColor()
    
    func displayError(_ on: ListingContainer,_ error: String?) {
        if let e = error {
            on.field.text = e
        }
        on.field.textColor = SpotitColors.errorColors.responseRed
        on.field.shape.strokeColor = SpotitColors.errorColors.responseRed.cgColor
        on.label.textColor = SpotitColors.errorColors.responseRed
    }
    
    func removeError(_ on : ListingContainer) {
        DispatchQueue.main.async {
            on.field.textColor = colors.lineColor.withAlphaComponent(0.9)
            on.field.shape.strokeColor = colors.purplishColor.cgColor
            on.label.textColor = colors.purplishColor
        }
    }
    
    func tapDismiss() {
        self.view.endEditing(true)
    }
    
    let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
    
    var deleteProgress : LinearGradientCircleLoader?
    
    func gradient(loader: LinearGradientCircleLoader, hasAppeared: Bool) {
        DispatchQueue.main.async {
            self.rotateView(view: self.deleteProgress!, duration: 0.4)
        }
    }
    
    func rotateView(view: UIView, duration: Double = 1) {
        if deleteProgress?.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(Double.pi * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            deleteProgress?.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    func stopRotatingView(_ button: UIButton,_ newTitle: String?) {
        if let title = newTitle {
            button.setTitle(title, for: .normal)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.deleteProgress?.alpha = 0
            button.titleLabel?.alpha = 1
        }, completion: { (v) in
            if self.deleteProgress?.layer.animation(forKey: self.kRotationAnimationKey) != nil {
                self.deleteProgress?.layer.removeAnimation(forKey: self.kRotationAnimationKey)
            }
        })
    }
    
    func addProgressIndicator(_ to: UIView, withSize: CGSize,_ given: CGSize,_ andColors: ColorGradient) {
        let r = CGRect(x: (withSize.width - given.width)/2, y: (withSize.height - given.height)/2, width: given.width, height: given.height)
        deleteProgress = LinearGradientCircleLoader(frame: r, colors: andColors)
        deleteProgress?.loadDelegate = self
        to.addSubview(deleteProgress!)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
