//
//  MainControllerTextField+Delegates.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-05.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase


extension MainController : UITextFieldDelegate {
    
    func searchDisplace(notification: NSNotification) {
        if let obj = notification.object {
        }
        guard let userInfo:NSDictionary = notification.userInfo as NSDictionary? else { return }
        guard let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let keybheight = keyboardHeight
        
        guard !App.defaults.leftApp else {
            dontiMessageKeyboardBugs = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self)
            return
        }
        guard dontiMessageKeyboardBugs else {
            dontiMessageKeyboardBugs = true
            searchDisplace(notification: notification)
            return
        }
        guard !blockSecondaryKeyboardCall else {
            return
        }
        blockSecondaryKeyboardCall = true
        searchField.delegate = self
        search.block.toggle()
        searchField.block.toggle()
        rightBut.block.toggle()
        statusBarStyle = .default
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.searchDisplays.alpha = 1
            self.searchDisplays.frame = CGRect(x: 0, y: self.searchRect.origin.y, width: self.searchRect.width, height: self.searchRect.height - keybheight)
            self.searchField.alpha = 1
            self.searchBorder.alpha = 1
            self.log.alpha = 0
            self.appLogo.alpha = 0
            self.search.layer.borderColor = colors.loginTfBack.cgColor
            self.statusBarView.backgroundColor  = colors.loginTfBack
            self.top.backgroundColor = colors.loginTfBack
            self.search.layer.cornerRadius = 0
            self.top.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (v) in
            self.blockSecondaryKeyboardCall = false
        }
    }
    
    func searchReplace(notification: NSNotification) {
        
        guard !App.defaults.leftApp else {
            doiMessageKeyboardBugs = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self)
            return
        }
        guard doiMessageKeyboardBugs else {
            doiMessageKeyboardBugs = true
            return
        }
        guard !blockSecondaryKeyboardHideCall else { return }
        blockSecondaryKeyboardHideCall = true
        searchField.delegate = nil
        search.block.toggle()
        searchField.block.toggle()
        rightBut.block.toggle()
        statusBarStyle = .lightContent
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.searchField.frame = CGRect(x: 0, y: 0, width: self.searchRect.width, height: self.searchRect.height)
            self.searchDisplays.alpha = 0
            self.searchDisplays.frame = self.searchRect
            self.searchField.alpha = 0
            self.searchBorder.alpha = 0
            self.appLogo.alpha = 1
            self.log.alpha = 1
            self.search.layer.borderColor = colors.lineColor.withAlphaComponent(0.8).cgColor
            self.statusBarView.backgroundColor  = colors.purplishColor
            self.top.backgroundColor = colors.purplishColor
            self.search.layer.cornerRadius = 1
            self.top.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (v) in
            self.blockSecondaryKeyboardHideCall = false
            self.clearAllSearchElements()
        }
    }
    
    //Selector for right but
    func openSearch() {
        leftBut.hybridToggleWith(true) { (v) -> Bool in
            return false
        }
    }
    
    func toggleSideMenu() {
        leftBut.hybridToggleWith(true) { (v) -> Bool in
            return true
        }
    }
    
    func dismissSearch() {
        searchField.resignFirstResponder()
    }
    
    fileprivate func performSearchOnCache(_ text: String) {
        ContactsCache.pipe.searchContactsFor(text) { (n) in
            if let new = n {
                contactSearch = new
            } else {
                contactSearch.removeAll()
            }
            DispatchQueue.main.async {
                self.searchDisplays.reloadData()
            }
        }
    }
    
    fileprivate func performSearchOnResults(_ text: String) {
        if let new = contactSearch.search(text) {
            contactSearch = new
            DispatchQueue.main.async {
                self.searchDisplays.reloadData()
            }
        } else {
            contactSearch.removeAll()
            DispatchQueue.main.async {
                self.searchDisplays.reloadData()
            }
        }
    }
    
    func determineSearchType(_ text: String) -> Bool {
        if contactSearch.isEmpty {
            performSearchOnCache(text)
        } else {
            performSearchOnResults(text)
        }
        return true
    }
    
    func determineSearchTypeForDeleting(_ text: String) -> Bool {
        var t = text
        _ = t.characters.popLast()
        performSearchOnCache(t)
        return true
    }
    
    func clearAllSearchElements() {
        contactSearch.removeAll()
        DispatchQueue.main.async {
            self.searchDisplays.reloadData()
        }
        searchField.text = nil
        showTip()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        contactSearch.removeAll()
        DispatchQueue.main.async {
            self.showTip()
            self.searchDisplays.reloadData()
        }
        return true
    }
    
    func hideTip() {
        searchTip.alpha = 0
    }
    
    func showTip() {
        searchTip.alpha = 1
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchField {
            guard let value = textField.text else { return true }
            if value.characters.count == 0 && string.characters.count == 0 {
                showTip()
                if contactSearch.isEmpty {
                } else {
                    contactSearch.removeAll()
                    searchDisplays.reloadData()
                }
                return false
            }
            if value.characters.count > 0 && string.characters.count == 0 {
                if value.characters.count == 1 {
                    showTip()
                    contactSearch.removeAll()
                    DispatchQueue.main.async {
                        self.searchDisplays.reloadData()
                    }
                    return true
                }
                hideTip()
                let text = textField.text! + string
                return determineSearchTypeForDeleting(text)
            }
            if (value.characters.count > 0 && string.characters.count > 0) || (value.characters.count == 0 && string.characters.count > 0) {
                hideTip()
                let text = value + string
                return determineSearchType(text)
            }
        }
        return true
    }
    
}

class SearchResultHighlightOptions {
    
    var font : UIFont
    var color : UIColor?
    
    init(font: UIFont, color: UIColor?) {
        self.font = font
        self.color = color
    }
    
}

class ContactSearchValue {
    
    var value : String
    var search : String
    var searchHightlight : SearchResultHighlightOptions
    
    init(value: String, search: String,highlight: SearchResultHighlightOptions?) {
        self.value = value
        self.search = search
        if let t = highlight {
            self.searchHightlight = t
        } else {
            self.searchHightlight = SearchResultHighlightOptions(font: GlobalFonts.bold.regularDescriptionSubTitle, color: colors.lineColor.withAlphaComponent(0.9))
        }
    }
    
    func attributedString(_ referenceFont: UIFont,_ referenceColor: UIColor) -> NSMutableAttributedString? {
        return self.value.stringWithSearch(search, [NSFontAttributeName: searchHightlight.font, NSForegroundColorAttributeName: searchHightlight.color != nil ? searchHightlight.color! : UIColor.black], [NSFontAttributeName: referenceFont, NSForegroundColorAttributeName: referenceColor]) as? NSMutableAttributedString
    }
    
}

class ContactSearchResult {
    var contact : Contact
    var results : [[ContactParameter:ContactSearchValue]]
    var reference : [String:Any]?
    init(c: Contact, results: [[ContactParameter:ContactSearchValue]]) {
        self.contact = c
        self.results = results
    }
    
    func resultingString(_ referenceFont: UIFont,_ referenceColor: UIColor) -> NSMutableAttributedString {
        let original = NSMutableAttributedString()
        let middle = NSAttributedString(string: ", ", attributes: [NSFontAttributeName: referenceFont, NSForegroundColorAttributeName: referenceColor])
        for item in results {
            for (_, item) in item.enumerated() {
                if let new = item.value.attributedString(referenceFont, referenceColor) {
                    if original.string.characters.count > 0 {
                        original.append(middle)
                        original.append(new as NSAttributedString)
                    } else {
                        original.append(new as NSAttributedString)
                    }
                }
            }
        }
        return original
    }
    
}

var contactSearch : [ContactSearchResult] = []

extension Array where Element == Contact {
    
    func search(_ with: String) -> [ContactSearchResult]? {
        var results : [ContactSearchResult] = []
        for (_, item) in self.enumerated() {
            let search = item.search(with)
            if search.0 {
                results.append(search.1)
            }
        }
        guard results.isEmpty else {
            results.sort {return $0.results.count > $1.results.count}
            return results
        }
        return nil
    }
    
}

extension Array where Element == ContactSearchResult {
    
    func search(_ with: String) -> [ContactSearchResult]? {
        var results : [ContactSearchResult] = []
        for (_, item) in self.enumerated() {
            let search = item.contact.search(with)
            if search.0 {
                results.append(search.1)
            }
        }
        guard results.isEmpty else {
            results.sort {return $0.results.count > $1.results.count}
            return results
        }
        return nil
    }
    
}

extension Contact {
    
    func search(_ with: String) -> (Bool,ContactSearchResult) {
        var result : Bool = false
        let with = with.lowercased()
        var containedIn : [[ContactParameter:ContactSearchValue]] = []
        if name.lowercased().contains(with) {
            result = true
            let result = ContactSearchValue(value: name, search: with, highlight: SearchResultHighlightOptions(font: GlobalFonts.bold.regularDescriptionSubTitle, color: colors.lineColor.withAlphaComponent(0.9)))
            containedIn.append([ContactParameter.name : result])
        }
        if let l = lastName, l.lowercased().contains(with) {
            result = true
            let result = ContactSearchValue(value: l, search: with, highlight: SearchResultHighlightOptions(font: GlobalFonts.bold.regularDescriptionSubTitle, color: colors.lineColor.withAlphaComponent(0.9)))
            containedIn.append([ContactParameter.last : result])
        }
        if let e = email, e.lowercased().contains(with) {
            result = true
            let result = ContactSearchValue(value: e, search: with, highlight: SearchResultHighlightOptions(font: GlobalFonts.bold.regularDescriptionSubTitle, color: colors.lineColor.withAlphaComponent(0.9)))
            containedIn.append([ContactParameter.email : result])
        }
        if jobTitle.lowercased().contains(with) {
            result = true
            let result = ContactSearchValue(value: jobTitle, search: with, highlight: SearchResultHighlightOptions(font: GlobalFonts.bold.regularDescriptionSubTitle, color: colors.lineColor.withAlphaComponent(0.9)))
            containedIn.append([ContactParameter.title : result])
        }
        if company.lowercased().contains(with) {
            result = true
            let result = ContactSearchValue(value: company, search: with, highlight: SearchResultHighlightOptions(font: GlobalFonts.bold.regularDescriptionSubTitle, color: colors.lineColor.withAlphaComponent(0.9)))
            containedIn.append([ContactParameter.corp : result])
        }
        return (result, ContactSearchResult(c: self, results: containedIn))
    }
    
}


extension String {
    
}
