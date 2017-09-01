//
//  ActionProfile+CollectionHelpers.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-29.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension ActionProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ActionProfileCellDelegate {
    
    func profile(cell: ActionProfileCell, wasSelected: Bool, withInfo: ActionButton) {
        print("Select Delegate")
        guard let d = self.actionDelegate else { return }
        print("This")
        d.action(profile: self, selected: withInfo, with: currentContact, atIndexPath: index!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection Selected")
        guard let d = self.actionDelegate else { return }
        let button = ActionButton()
        if let cell = collectionView.cellForItem(at: indexPath) as? ActionProfileCell, let attribute = cell.attribute {
            switch attribute {
            case .email(let v):
                button.setAttribute("contact_email", v)
            case .nav(let v):
                button.setAttribute("contact_loc", v)
            case .phone(let v):
                button.setAttribute("contact_phone", v)
            case .profile(let v):
                button.setAttribute("contact_profile", v)
            case .sms(let v):
                button.setAttribute("contact_sms", v)
            }
            d.action(profile: self, selected: button, with: currentContact, atIndexPath: index!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return params.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionProfileCell
        cell.attribute = params[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}
