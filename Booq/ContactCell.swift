//
//  ContactCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase



struct CellFonts {
    
    static var title : UIFont {
        guard let t = UIFont(name: "Lato-Regular", size: 19) else {
            return UIFont.boldSystemFont(ofSize: 18)
        }
        return t
    }
    
    static let subtext : UIFont = UIFont.systemFont(ofSize: 15)
}

enum ContactActionValues : StringLiteralType {
    case call = "contact_phone"
    case sms = "contact_sms"
    case email = "contact_email"
    case loc = "contact_loc"
    case profile = "contact_profile"
}

protocol ContactCellActionDelegate {
    func action(button: ActionButton, wasPressed: IndexPath)
}

extension LocalizedImageView {
    
    
    func loadImageFromContact(_ value: String) {
        if value.contains("http") {
            ImageCache.main.applyProfilePic(value, nil) { (profileObject) in
                guard let ob = profileObject, let im = ob.image else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = im
                }
                let it = ContactsCache.pipe.contacts.filter({ return $0.picUrl! == value })
                if let itt = it.first {
                    itt.picUrl = ob.id
                    ContactsCD.node.add(itt)
                }
            }
        } else {
            if let img = ImageCache.main.profilePics.object(forKey: value as NSString) as? UIImage {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }
    }
    
}


protocol ContactCellDelegate : NSObjectProtocol{
    func contact(cell: ContactCell, indexPath: IndexPath, contact: Contact)
}


class ContactCell : BaseCell, UIGestureRecognizerDelegate, ProfileHeaderActionButtonDelegate{
    
    var contact = Contact() {
        didSet {
            applyLayout()
        }
    }
    
    var values : (Contact, IndexPath)? {
        didSet {
            if let t = values {
                applyLayout(t.0)
                ContactsCache.pipe.updateIndexPathFor(t.0.id, index: t.1, { (index) in
                    if let ind = index {
                        self.indexPath = ind
                    }
                })
            }
        }
    }
    
    var indexPath = IndexPath() {
        didSet {
            if let it = ContactsCache.pipe.currentlyChanging[self.indexPath] {
                switch it {
                case .normal(_):
                    self.resetWith(cellSizes.normal)
                case .selected(_):
                    self.resetWith(cellSizes.expanded)
                }
            } else {
                self.resetWith(cellSizes.normal)
            }
        }
    }
    
    var expandedState = CellSizeState()
    
    var selectionDelegate : ContactCellDelegate?
    
    var actionDelegate : ContactCellActionDelegate?
    
    var toggleExpandState : (()->())?
    
    private var pic : LocalizedImageView = {
        var v = LocalizedImageView(secondaries: false, cornerRadius: 5)
        v.translatesAutoresizingMaskIntoConstraints = true
        return v
    }()
    
    private var name : Label = {
        var v = Label(secondaries: false)
        v.textColor = colors.lineColor
        v.font = CellFonts.title
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = true
        return v
    }()
    
    private var subname : Label = {
        var v = Label(secondaries: false)
        v.textColor = colors.lineColor.withAlphaComponent(0.85)
        v.font = GlobalFonts.regularTitle
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = true
        return v
    }()
    
    private var container : View = {
        var v = View(secondaries: false)
        v.backgroundColor = colors.loginTfBack
        return v
    }()
    
    private var top : View = {
        var v = View(secondaries: false)
        return v
    }()
    
    var buttons : View = {
        var v = View(secondaries: false)
        return v
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = colors.loginTfBack
        addSubview(pic)
        addSubview(name)
        addSubview(subname)
        
        borderWidth = 0.75
        
        lineColor = colors.lineColor.withAlphaComponent(0.45)
        
        /*let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height + 2), cornerRadius: 2).cgPath
        layer.shadowPath = path
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.8
        layer.cornerRadius = 2*/
        
        self.constrain()
        self.toggleExpandState = {
            if let d = self.selectionDelegate {
                d.contact(cell: self, indexPath: self.indexPath, contact: self.contact)
            }
        }
    }
    
    func parseContactIntoButtonLayoutThroughDispatch() {
        performConcurrently()
    }
    
    func performConcurrently() {
        DispatchQueue.global(qos: .utility).async {
            self.parseContactIntoButtonLayout()
        }
    }
    
    func concurrently(_ compute: @escaping(()->())) {
        DispatchQueue.global(qos: .userInitiated).async(execute: compute)
    }
    
    func performOnMain(_ compute: @escaping(()->())) {
        DispatchQueue.main.async(execute: compute)
    }
    
    func performOnMainSync(_ compute: @escaping(()->())) {
        DispatchQueue.main.sync(execute: compute)
    }
    
    func applyLayout(_ with: Contact) {
        self.contact = with
    }
    
    func applyLayout() {
        var name = contact.name
        if let last = contact.lastName {
            name = name + " \(last)"
        }
        subname.text = contact.jobDescriptionTwoLinesJob
        self.name.text = name
    }
    
    func applyPicture(){
        if let url = contact.picUrl {
            pic.loadFrom(urlString: url)
        }
    }

    
    func parseContactIntoButtonLayout() {
    }
    
    var buttonsSides : CGFloat = 3
    
    func resetDisplays() {
    }
    
    func applyThings() {
        var name = contact.name
        if let last = contact.lastName {
            name = name + " \(last)"
        }
        subname.text = contact.jobDescriptionTwoLinesJob
        self.name.text = name
        parseContactIntoButtonLayout()
    }
    
    func resetWith(_ size: CGSize) {
        /*let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width - 10, height: self.frame.height), cornerRadius: 4).cgPath
        container.layer.shadowPath = path
        container.layer.shadowRadius = 6.0
        container.layer.shadowOffset = CGSize(width: 0, height: 8)
        container.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.cornerRadius = 4*/
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func constrain() {
        
        /*addConstraintsWithFormat(format: "H:[v0(\(cellSizes.normal.height - 20))]", views: pic)
        addConstraintsWithFormat(format: "V:|-\(10)-[v0]-\(10)-|", views: pic)
        addConstraintsWithFormat(format: "V:|-\(10)-[v0][v1]-\(10)-|", views: name, subname)
        addConstraintsWithFormat(format: "H:|-\(10)-[v0]-\(10)-[v1]-\(10)-|", views: pic, name)
        addConstraintsWithFormat(format: "H:|-\(10)-[v0]-\(16)-[v1]-\(10)-|", views: pic, subname)*/
        
        container.block.topConstraint = container.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        container.block.bottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        container.block.leftConstraint = container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        container.block.rightConstraint = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        
        /*top.block.topConstraint = top.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        top.block.leftConstraint = top.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        top.block.rightConstraint = top.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        top.block.heightConstraint = top.heightAnchor.constraint(equalToConstant: cellSizes.normal.height)*/
        
        pic.block.widthConstraint = pic.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
        pic.block.heightConstraint = pic.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
        pic.block.rightConstraint = pic.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        pic.block.vertical = pic.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        
        name.block.topConstraint = name.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        name.block.leftConstraint = name.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 10)
        name.block.rightConstraint = name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        name.block.heightConstraint = name.heightAnchor.constraint(equalTo: pic.heightAnchor, multiplier: 0.4, constant: 0)
        
        subname.block.topConstraint = subname.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0)
        subname.block.rightConstraint = subname.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        subname.block.leftConstraint = subname.leadingAnchor.constraint(equalTo: pic.trailingAnchor, constant: 10)
        subname.block.bottomConstraint = subname.bottomAnchor.constraint(equalTo: pic.bottomAnchor, constant: 0)
        
        
        /*buttons.block.topConstraint = buttons.topAnchor.constraint(equalTo: top.bottomAnchor, constant: 0)
        buttons.block.bottomConstraint = buttons.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        buttons.block.leftConstraint = buttons.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        buttons.block.rightConstraint = buttons.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)*/
        
        //self.container.activateConstraints()
        
        self.pic.activateConstraints()
        self.name.activateConstraints()
        self.subname.activateConstraints()
        
        self.imposeTouch()
        
    }
    
    private func imposeTouch() {
        let touch = UITapGestureRecognizer()
        touch.addTarget(self, action: #selector(handleExpand))
        self.addGestureRecognizer(touch)
    }
    
    private func applyShadows() {
        if let height = container.block.topConstraint, let bottom = container.block.bottomConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width - 10, height: self.frame.height - (height.constant - bottom.constant)), cornerRadius: 4).cgPath
            container.layer.shadowPath = path
            container.layer.shadowRadius = 6.0
            container.layer.shadowOffset = CGSize(width: 0, height: 8)
            container.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            container.layer.shadowOpacity = 0.5
            container.layer.cornerRadius = 4
        }
    }
    
    func handleExpand() {
        toggleExpandState?()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
    }
    
    func header(button: ActionButton, wasPressed info: Any?) {
        if let d = self.actionDelegate {
            d.action(button: button, wasPressed: self.indexPath)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

