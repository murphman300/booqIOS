//
//  MainControllerCollectionViews+Helpers.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-24.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

var searchID = "searchCellID"

extension MainController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SearchCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchDisplays {
            return contactSearch.count
        } else {
            return ContactsCache.pipe.contacts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchDisplays {
            return handleSearchCell(collectionView, cellForItemAt: indexPath)
        } else {
            return handleMainCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchDisplays {
            return cellSizes.searchCell
        } else {
            return cellSizes.normal
        }
    }
    
    func search(cell: SearchCell, wasSelected: IndexPath, with: Contact) {
        guard let found = main.cellForItem(at: wasSelected) as? ContactCell else {
            toggleSideMenu()
            openActionViewFor(with, at: wasSelected)
            return
        }
        if found.contact == with {
            toggleSideMenu()
            openActionViewFor(with, at: wasSelected)
        }
    }
    
    func handleMainCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ContactCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contactID, for: indexPath) as! ContactCell
        let contact = ContactsCache.pipe.contacts[indexPath.item]
        cell.selectionDelegate = self
        cell.actionDelegate = self
        cell.values = (contact, indexPath)
        cell.applyPicture()
        cell.indexType = (indexPath, ContactsCache.pipe.contacts.count)
        ContactsCache.pipe.indexPathToContacts[contact.id] = indexPath
        return cell
    }
    
    func handleSearchCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> SearchCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchID, for: indexPath) as! SearchCell
        cell.result = contactSearch[indexPath.item]
        cell.delegate = self
        return cell
    }
}
