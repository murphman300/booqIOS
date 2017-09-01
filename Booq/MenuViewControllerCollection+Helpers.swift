//
//  MenuViewControllerCollection+Helpers.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension MenuViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let t = MenuSections.list().count
        return t
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let it = MenuSections.list()[section].first!
        return it.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return handleCellForSection(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return handleCellSize(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return handleSectionHeader(collection: collectionView, kind: kind, index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section != MenuSections.list().count - 1 else { return .zero}
        return CGSize(width: self.view.frame.width, height: buttonSizes.mainheight * 1.3)
    }
    
    
    func handleCellSize(_ path: IndexPath) -> CGSize {
        let list = MenuSections.list()
        if path.section == list.count - 1 {
            guard let this = MenuSections.list().last?.first, let item = BottomMenuCells(rawValue: this.value[path.item]) else { return .zero }
            switch item {
            case .appState:
                return CGSize(width: view.frame.width, height: buttonSizes.mainheight * 1.75)
            }
        }
        return CGSize(width: view.frame.width, height: buttonSizes.mainheight * 1.2)
    }
    
    func handleSectionHeader(collection: UICollectionView, kind: String, index : IndexPath) -> UICollectionReusableView {
        let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: menuListingHeaderID, for: index) as! MenuListingHeader
        if let h = MenuListingSections(rawValue: index.section) {
            header.label.text = h.value
        }
        return header
    }
    
    func handleCellForSection(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let first = MenuSections.list()[indexPath.section].first!
        let key = first.key
        switch key {
        case .legal, .beta:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! SelectionMenuCell
            cell.indexType = (indexPath, first.value.count)
            cell.type = indexPath
            cell.delegate = self
            return cell
        case .bottom:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayCell", for: indexPath) as! DisplayMenuCell
            cell.type = indexPath
            return cell
        }
    }
    
}
