//
//  SearchCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-25.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

protocol SearchCellDelegate {
    func search(cell: SearchCell, wasSelected: IndexPath, with: Contact)
}

class SearchCell: BaseCell {
    
    var result : ContactSearchResult? {
        didSet {
            if let r = result {
                if let p = r.contact.picUrl {
                    pic.loadFrom(urlString: p)
                }
                ContactsCache.pipe.fetchIndexPathFor(r.contact.id, { (index) in
                    if let ind = index {
                        self.indexPath = ind
                    } else {
                    }
                })
                if let last = r.contact.lastName {
                    label.text = r.contact.name + " \(last)"
                } else {
                    label.text = r.contact.name
                }
                let string = r.resultingString(GlobalFonts.regularDescriptionSubTitle, colors.lineColor.withAlphaComponent(0.7))
                DispatchQueue.main.async {
                    self.sublabel.attributedText = string
                }
            }
        }
        
    }
    
    var delegate : SearchCellDelegate?
    
    private var indexPath : IndexPath?
    
    var pic : LocalizedImageView = {
        var i = LocalizedImageView(secondaries: false, cornerRadius: 0.0)
        return i
    }()
    
    var label : Label = {
        var l = Label(secondaries: false)
        l.font = GlobalFonts.regularTitle
        l.textColor = colors.lineColor.withAlphaComponent(0.9)
        return l
    }()
    
    var sublabel : Label = {
        var l = Label(secondaries: false)
        l.font = GlobalFonts.regularDescriptionSubTitle
        l.textColor = colors.lineColor.withAlphaComponent(0.7)
        l.numberOfLines = 0
        return l
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(pic)
        addSubview(label)
        addSubview(sublabel)
        let h = frame.height - 10
        let h2 = (frame.height - 10) * 0.6
        addConstraintsWithFormat(format: "V:|-\(5)-[v0]-\(5)-|", views: pic)
        addConstraintsWithFormat(format: "V:|-\(5)-[v0(\(h2))][v1]-\(5)-|", views: label, sublabel)
        addConstraintsWithFormat(format: "H:|-\(10)-[v0(\(h))]-\(10)-[v1]-\(10)-|", views: pic, label)
        addConstraintsWithFormat(format: "H:|-\(10)-[v0(\(h))]-\(10)-[v1]-\(10)-|", views: pic, sublabel)
        pic.layer.cornerRadius = h/2
        backgroundColor = UIColor.rgb(red: 253, green: 253, blue: 253)
        
        let border = UIView()
        addSubview(border)
        border.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        border.backgroundColor = colors.lineColor.withAlphaComponent(0.8)
        let t = UITapGestureRecognizer(target: self, action: #selector(selected))
        addGestureRecognizer(t)
    }
    
    @objc private func selected() {
        if let d = self.delegate, let index = self.indexPath, let res = self.result {
            d.search(cell: self, wasSelected: index, with: res.contact)
        }
    }
    
}


