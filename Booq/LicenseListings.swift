//
//  LicenseListings.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-31.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

class LicenseListings : SelectorView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, LicenseListingDelegate {
    
    var main : CollectionView = {
       var lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .vertical
        lay.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        var m = CollectionView(frame: .zero, collectionViewLayout: lay)
        m.backgroundColor = .clear
        return m
    }()
    
    private var listingID = "listingID"
    
    var licenseDelegate : LicenseListingDelegate?
    
    var allLicenses : [Int] = []
    
    override func set(_ frame: CGRect) {
        allLicenses = AppLicense.all().array()
        addSubview(main)
        main.top(self, .top, ConstraintVariables(.top, 0.0).fixConstant(), nil)
        main.left(self, .left, ConstraintVariables(.left, 0.0).fixConstant(), nil)
        main.right(self, .right, ConstraintVariables(.right, 0.0).fixConstant(), nil)
        main.bottom(self, .bottom, ConstraintVariables(.bottom, 0.0).fixConstant(), nil)
        main.activateConstraints()
        main.register(LicenseListingCell.self, forCellWithReuseIdentifier: listingID)
        main.dataSource = self
        main.delegate = self
        super.set(frame)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allLicenses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listingID, for: indexPath) as! LicenseListingCell
        if let license = AppLicense(rawValue: allLicenses[indexPath.item]) {
            cell.license = license
        }
        cell.delegate = self.licenseDelegate != nil ? self.licenseDelegate! : self
        cell.indexType = (indexPath, allLicenses.count - 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screen.width, height: buttonSizes.mainheight * 1.2)
    }
    
    func license(cell: LicenseListingCell, wasPressed: Bool, with: AppLicense) {
        if let d = self.licenseDelegate {
            d.license(cell: cell, wasPressed: wasPressed, with: with)
        }
    }
    
}
