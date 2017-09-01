//
//  ContactCellLayout.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-16.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase



class LayoutForCell {
    
    var layout : [ImagedActionButton] = []
    
    var blocks : [ContactActionValues:ConstraintBlock] = [:]
    
    var profile = ConstraintBlock()
    var phone = ConstraintBlock()
    var email = ConstraintBlock()
    var sms = ConstraintBlock()
    var zip = ConstraintBlock()
    
    var count = Int()
    var lefty = CGFloat()
    var righty = CGFloat()
    var left = CGFloat()
    var spacing = CGFloat()
    /*
    func applyLayout(_ contact: Contact, cell: ContactCell) {
        
        if let p = contact.phone {
            cell.phoneCall.setAttribute("contact_phone", p)
            cell.phoneCall.setAttribute("value", ContactActionValues.call)
            cell.phoneSMS.setAttribute("contact_sms", p)
            cell.phoneSMS.setAttribute("value", ContactActionValues.sms)
            layout.append(cell.phoneCall)
            layout.append(cell.phoneSMS)
            cell.phoneCall.image = UIImage(named: "9243")!
            cell.phoneSMS.image = #imageLiteral(resourceName: "basic2-4")
        }
        if let p = cell.contact.email, p.characters.count >= 9 {
            do {
                let t = try Email(entry: p)
                cell.writeEmail.setAttribute("contact_email", t)
                cell.writeEmail.setAttribute("value", ContactActionValues.email)
                layout.append(cell.writeEmail)
                cell.writeEmail.image = #imageLiteral(resourceName: "emailIcon")
            } catch {
                print("No Email")
            }
        }
        if let p = contact.postalCode, p.characters.count == 6 {
            let t = PostalCode()
            t.code = p
            cell.navTo.setAttribute("contact_loc", t)
            cell.navTo.setAttribute("value", ContactActionValues.loc)
            layout.append(cell.navTo)
        }
        layout.append(cell.viewProfile)
        if !contact.name.isEmpty {
            cell.viewProfile.setAttribute("contact_profile", contact)
            cell.viewProfile.setAttribute("value", ContactActionValues.profile)
        }
        cell.viewProfile.image = #imageLiteral(resourceName: "userMaleIcon")
        count = layout.count
        lefty = (cell.frame.width - 10 - (cell.buttonsSides * 2))
        righty = (cellSizes.diff.height * 0.9 * CGFloat(count))
        left = lefty - righty
        spacing = (left) / CGFloat(count + 1)
        for (index, item) in layout.enumerated() {
            cell.buttons.addSubview(item)
            item.delegate = cell
            item.block.heightConstraint = item.heightAnchor.constraint(equalTo: cell.buttons.heightAnchor, multiplier: 0.9)
            item.block.widthConstraint = item.widthAnchor.constraint(equalTo: cell.buttons.heightAnchor, multiplier: 0.9)
            item.block.vertical = item.centerYAnchor.constraint(equalTo: cell.buttons.centerYAnchor, constant: 1.0)
            let lead = (CGFloat(index + 1) * spacing) + (cellSizes.diff.height * 0.9 * CGFloat(index))
            item.block.rightConstraint = item.leadingAnchor.constraint(equalTo: cell.buttons.leadingAnchor, constant: lead)
            if let t = item.attributes, let v = t["value"] as? ContactActionValues {
                blocks[v] = item.block
            }
            item.activateConstraints()
        }
    }
    */
}
