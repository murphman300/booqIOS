//
//  MainControllerBuilderMethods.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension MainController {
    
    func applyInitialsAndViews() {
        
        view.addSubview(main)
        view.addSubview(add)
        view.addSubview(top)
        view.addSubview(loading)
        view.addSubview(appLogo)
        
        view.addSubview(searchDisplays)
        searchDisplays.addSubview(searchTip)
        
        top.addSubview(search)
        top.addSubview(leftBut)
        top.addSubview(searchBorder)
        
        search.addSubview(rightBut)
        search.addSubview(searchField)
        search.addSubview(log)
        
        self.setConstraints()
        
        self.addLayers()
        
        self.makeLoading()
        
        self.rightBut.imageV.changeColorTo(colors.loginTfBack)
        
        self.view.addSubview(self.statusBarView)
        
        main.register(ContactCell.self, forCellWithReuseIdentifier: contactID)
        searchDisplays.register(SearchCell.self, forCellWithReuseIdentifier: searchID)
        
        if App.defaults.configured {
            self.setCollection()
        }
        menuTap.addTarget(self, action: #selector(menuPresenter))
    }
    
    fileprivate func didAppearAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.changeTopBarFromInitial()
        }) { (v) in
            self.add.block.toggle()
            UIView.animate(withDuration: 0.35, animations: {
                self.view.layoutIfNeeded()
                self.add.alpha = 1
            }) { (v) in
                self.searchField.addSolidBorder(.bottom, colors.lineColor, (screen.width - 4) * 0.9)
            }
            
        }
    }
    
    func didAppearWithConfiguration() {
        notPresented = false
        setScrollIndicatorColor(color: colors.purplishColor)
        self.add.delegate = self
        self.reapplyLogoPic()
        didAppearAnimation()
    }
    
    func didAppearWithoutConfiguration() {
        FirebaseManager.node.getAllInitial({ (new) in
            ContactsCache.pipe.contacts = new
            self.setCollection()
            if ContactsCD.node.configureInitial() {
                DispatchQueue.main.async {
                    guard self.notPresented else { return }
                    self.notPresented = false
                    self.setScrollIndicatorColor(color: colors.purplishColor)
                    self.add.delegate = self
                    self.reapplyLogoPic()
                    self.didAppearAnimation()
                }
            }
        }, {
            print("Failed to get initial Contacts")
        })
    }
    
    func setConstraints() {
        
        let topHeight = buttonSizes.mainheight * 1.2
        let searchHeight = buttonSizes.mainheight * 1.1
        
        statusBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        
        main.frame = CGRect(x: 0, y: 20 + topHeight, width: view.frame.width, height: view.frame.height - topHeight - 20)
        
        add.block.widthConstraint = add.widthAnchor.constraint(equalToConstant: buttonSizes.mainheight * 1.5)
        add.block.heightConstraint = add.heightAnchor.constraint(equalToConstant: buttonSizes.mainheight * 1.5)
        add.block.bottomConstraint = add.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        add.block.rightConstraint = add.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        
        add.block.secondaries?.leftConstraint = add.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        
        add.block.primary = {
            self.add.block.switchStates(.right, .left)
        }
        add.block.secondary = {
            self.add.block.switchStates(.left, .right)
        }
        add.block.primaryAndSecondaryCanToggle = true
        
        
        top.block.topConstraint = top.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        top.block.heightConstraint = top.heightAnchor.constraint(equalToConstant: topHeight)
        top.block.rightConstraint = top.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        top.block.leftConstraint = top.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        
        top.block.primary = {
            self.top.block.switchStates(.right, .left)
        }
        top.block.secondary = {
            self.top.block.switchStates(.left, .right)
        }
        top.block.primaryAndSecondaryCanToggle = true
        
        search.block.topConstraint = search.topAnchor.constraint(equalTo: top.topAnchor, constant: topHeight * 0.1)
        search.block.heightConstraint = search.heightAnchor.constraint(equalToConstant: searchHeight)
        search.block.rightConstraint = search.leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: 2)
        search.block.leftConstraint = search.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: -2)
        
        search.block.secondaries?.topConstraint = search.topAnchor.constraint(equalTo: top.topAnchor, constant: 0)
        search.block.secondaries?.rightConstraint = search.leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: 0)
        search.block.secondaries?.leftConstraint = search.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: 0)
        
        search.block.primary = {
            self.search.block.switchStates(.right, .right)
            self.search.block.switchStates(.left, .left)
            self.search.block.switchStates(.top, .top)
        }
        search.block.secondary = {
            self.search.block.switchStates(.right, .right)
            self.search.block.switchStates(.left, .left)
            self.search.block.switchStates(.top, .top)
        }
        search.block.primaryAndSecondaryCanToggle = true
        
        searchField.block.topConstraint = searchField.topAnchor.constraint(equalTo: search.topAnchor, constant: 8)
        searchField.block.rightConstraint = searchField.leadingAnchor.constraint(equalTo: search.leadingAnchor, constant: searchHeight * 1.2)
        searchField.block.leftConstraint = searchField.trailingAnchor.constraint(equalTo: search.trailingAnchor, constant: -searchHeight)
        searchField.block.bottomConstraint = searchField.bottomAnchor.constraint(equalTo: search.bottomAnchor, constant: -8)
        searchField.block.secondaries?.leftConstraint = searchField.trailingAnchor.constraint(equalTo: search.trailingAnchor, constant: -(searchHeight * 0.25))
        searchField.block.primary = {
            self.searchField.block.switchStates(.left, .left)
        }
        searchField.block.secondary = {
            self.searchField.block.switchStates(.left, .left)
        }
        searchField.block.primaryAndSecondaryCanToggle = true
        
        let searchB = View(secondaries: true)
        searchField.addSubview(searchB)
        searchB.backgroundColor = colors.lineColor.withAlphaComponent(0.95)
        searchB.height(search, .height, ConstraintVariables(.height, 1.5).fixConstant(), nil)
        searchB.top(searchField, .bottom, ConstraintVariables(.top, 0).fixConstant(), nil)
        searchB.left(searchField, .left, ConstraintVariables(.left, 0).fixConstant(), nil)
        searchB.right(searchField, .right, ConstraintVariables(.right, 0).fixConstant(), nil)
        
        if let h = search.block.heightConstraint {
            searchRect = CGRect(x: 0, y: 20 + topHeight, width: view.frame.width, height: view.frame.height - (20 + topHeight))
            searchDisplays.frame = searchRect
            searchTip.frame = CGRect(x: 50, y: 0, width: searchRect.width - 100, height: searchRect.width - 100)
            searchBorder.frame = CGRect(x: 0, y: topHeight - 1, width: view.frame.width, height: 1)
        }
        
        leftBut.frame.size = CGSize(width: searchHeight * 0.45, height: searchHeight * 0.4)
        leftBut.center.x = searchHeight * 0.6
        leftBut.center.y = topHeight - (searchHeight / 2)
        leftBut.form()
        leftBut.type = .bottomArrow
        
        leftBut.selectedAction = { button, state in
            if state {
                self.menuPresenter()
            } else {
                self.searchField.becomeFirstResponder()
            }
        }
        
        leftBut.deselectedAction = { button, state in
            if state {
            } else {
                if self.searchField.isFirstResponder {
                    self.searchField.resignFirstResponder()
                }
            }
        }
        leftBut.isUserInteractionEnabled = true
        leftTap.addTarget(self, action: #selector(toggleSideMenu))
        leftBut.addGestureRecognizer(leftTap)
        
        rightBut.block.vertical = rightBut.centerYAnchor.constraint(equalTo: search.centerYAnchor, constant: 0)
        rightBut.block.heightConstraint = rightBut.heightAnchor.constraint(equalToConstant: searchHeight * 0.9)
        rightBut.block.widthConstraint = rightBut.widthAnchor.constraint(equalToConstant: searchHeight * 0.9)
        rightBut.block.secondaries?.heightConstraint = rightBut.heightAnchor.constraint(equalToConstant: 1)
        rightBut.block.secondaries?.widthConstraint = rightBut.widthAnchor.constraint(equalToConstant: 1)
        rightBut.block.leftConstraint = rightBut.trailingAnchor.constraint(equalTo: search.trailingAnchor, constant: -searchHeight * 0.25)
        
        self.rightBut.layer.cornerRadius = searchHeight * 0.9 * 0.5
        self.rightBut.layer.masksToBounds = true
        
        rightBut.block.primary = {
            self.rightBut.block.switchStates(.height, .height)
            self.rightBut.block.switchStates(.width, .width)
        }
        rightBut.block.secondary = {
            self.rightBut.block.switchStates(.height, .height)
            self.rightBut.block.switchStates(.width, .width)
        }
        rightBut.block.primaryAndSecondaryCanToggle = true
        rightBut.image = #imageLiteral(resourceName: "search-128")
        
        log.block.horizontal = log.centerXAnchor.constraint(equalTo: search.centerXAnchor, constant: 0)
        log.block.vertical = log.centerYAnchor.constraint(equalTo: search.centerYAnchor, constant: 0)
        log.block.heightConstraint = log.heightAnchor.constraint(equalToConstant: searchHeight)
        log.block.widthConstraint = log.widthAnchor.constraint(equalToConstant: searchHeight * 2)
        
        add.activateConstraints()
        top.activateConstraints()
        search.activateConstraints()
        searchField.activateConstraints()
        searchB.activateConstraints()
        searchDisplays.activateConstraints()
        rightBut.activateConstraints()
        log.activateConstraints()
        
        rightBut.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        
        provideImageToMainButton()
        provideShadowToSearch()
    }
    
    func pressLeftForMenu() {
        leftBut.toggleStateAndPerform(true) { (state) -> Bool in
            return true
        }
    }

    func provideImageToMainButton() {
        let image = #imageLiteral(resourceName: "BatchLogosWhiteStroke_Pin")
        let v = ImageView(secondaries: false, cornerRadius: 0.0)
        v.image = image
        add.addSubview(v)
        v.block.topConstraint = v.topAnchor.constraint(equalTo: add.topAnchor, constant: 15)
        v.block.leftConstraint = v.leadingAnchor.constraint(equalTo: add.leadingAnchor, constant: 15)
        v.block.rightConstraint = v.trailingAnchor.constraint(equalTo: add.trailingAnchor, constant: -15)
        v.block.bottomConstraint = v.bottomAnchor.constraint(equalTo: add.bottomAnchor, constant: -15)
        v.activateConstraints()
        v.contentMode = .scaleAspectFit
    }
    
    func provideShadowToSearch() {
        let path = UIBezierPath(roundedRect: CGRect(x: -1, y: 0, width: view.frame.width + 2, height: buttonSizes.mainheight * 1.2), cornerRadius: 0).cgPath
        top.layer.shadowPath = path
        top.layer.shadowRadius = 6.0
        top.layer.shadowOffset = CGSize(width: 0, height: 4)
        top.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        top.layer.shadowOpacity = 0.5
    }
    
    func setCollection() {
        main.delegate = self
        main.dataSource = self
        searchDisplays.delegate = self
        searchDisplays.dataSource = self
    }
    
    private func addLayers() {
        add.actionType = .null
        if let height = add.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: height.constant, height: height.constant), cornerRadius: height.constant / 2).cgPath
            add.layer.shadowPath = path
            add.layer.shadowRadius = 6.0
            add.layer.shadowOffset = CGSize(width: 0, height: 8)
            add.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            add.layer.shadowOpacity = 0.5
            add.layer.cornerRadius = height.constant / 2
        }
    }
    
}
