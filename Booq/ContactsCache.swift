//
//  ContactsCache.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation
import SCKBase

class ContactsCache {
    
    
    fileprivate let contactsThread = DispatchQueue(
        label: "Booq.Spotit.Contacts.Main", // 1
        attributes: .concurrent)
    
    fileprivate let contactsCellLayoutThread = DispatchQueue(
        label: "Booq.Spotit.Contacts.Main", // 1
        attributes: .concurrent)
    
    
    static let pipe = ContactsCache()
    
    private let cache = NSCache<NSString, Contact>()
    
    var contacts : [Contact] = []
    
    var currentlyChanging : [IndexPath:CellSizeState] = [:]
    
    var indexPathToContacts : [String:IndexPath] = [:]
    
    var cellLayouts : [String:LayoutForCell] = [:]
    
    private var indexes : [String:Int] = [:]
    
    init() {
        
    }
    
    private var blocker : Bool = true
    
    func configure() -> Bool {
        return ContactsCD.node.configure()
    }
    
    func syncContactsWithCache(_ contacts: [Contact]) {
        self.contacts = contacts.sorted(by: { return $0.added < $1.added} )
        for con in contacts {
            cache.setObject(con, forKey: con.id as NSString)
        }
    }
    
    func configureInitial(_ cache: [Contact]) -> Bool {
        return true
    }
    
    func updateIndexPathFor(_ id: String, index: IndexPath,_ done: ((IndexPath?)->())?) {
        self.contactsThread.sync {
            self.indexPathToContacts[id] = index
            done?(index)
        }
    }
    
    func fetchIndexPathFor(_ id: String,_ found: ((IndexPath?)->())?) {
        self.contactsThread.sync {
            if let t = self.indexPathToContacts[id] {
                found?(t)
            } else if let indValue = contacts.index(where: { (cont) -> Bool in
                return cont.id == id
            }) {
                let index = IndexPath(item: indValue, section: 0)
                self.indexPathToContacts[id] = index
                found?(index)
            } else {
                found?(nil)
            }
        }
    }
    
    func searchContactsFor(_ value: String,_ completion: @escaping (([ContactSearchResult]?)->())) {
        self.contactsCellLayoutThread.async {
            if let new = self.contacts.search(value) {
                completion(new)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchAllURLS(_ completion: @escaping (()->())) {
        for (index, item) in self.contacts.enumerated() {
            self.indexes[item.name] = index
            self.cache.setObject(item, forKey: item.id as NSString)
        }
        completion()
    }
    
    func update(_ contact: Contact) {
        contactsThread.async(group: nil, qos: .unspecified, flags: .barrier) {
            guard let current = self.cache.object(forKey: contact.id as NSString), let index = self.indexes[contact.id], current.id == contact.id else {
                self.contacts.insert(contact, at: 0)
                self.cache.setObject(contact, forKey: contact.id as NSString)
                self.reEvalutePositions()
                return
            }
            self.cache.setObject(contact, forKey: contact.id as NSString)
            self.contacts[index] = contact
            self.reEvalutePositions()
        }
    }
    
    func update(_ contact: Contact,_ with: (()->())?){
        contactsThread.async(group: nil, qos: .unspecified, flags: .barrier) {
            guard self.cache.object(forKey: contact.id as NSString) != nil, let index = ContactsCache.pipe.contacts.index(where: {return $0 == contact}) else {
                self.cache.setObject(contact, forKey: contact.id as NSString)
                self.reEvalutePositions(with)
                return
            }
            self.cache.setObject(contact, forKey: contact.id as NSString)
            self.contacts[index] = contact
            self.reEvalutePositions(with)
        }
    }
    
    func add(_ contact: Contact) {
        update(contact)
    }
    
    func delete(_ contact: Contact) {
        if let index = indexes[contact.id] {
            contacts.remove(at: index)
            cache.removeObject(forKey: contact.id as NSString)
            if indexes.removeValue(forKey: contact.id) != nil {
                print("Removed contact")
            }
        } else {
            cache.removeObject(forKey: contact.id as NSString)
            var ind : Int?
            for (index, item) in contacts.enumerated() {
                if item.id == contact.id {
                    ind = index
                    cache.removeObject(forKey: contact.id as NSString)
                    indexes.removeValue(forKey: contact.id)
                }
            }
            if let i = ind {
                contacts.remove(at: i)
            }
        }
    }
    
    private func reEvalutePositions() {
        for (index, item) in contacts.enumerated() {
            indexes[item.name] = index
            cache.setObject(item, forKey: item.id as NSString)
        }
    }
    private func reEvalutePositions(_ with: (()->())?) {
        for (index, item) in contacts.enumerated() {
            indexes[item.name] = index
            cache.setObject(item, forKey: item.id as NSString)
        }
        with?()
    }
    
    func performLayoutCalculation(_ calcs: @escaping(()->()),_ layouts: @escaping(()->())) {
        contactsCellLayoutThread.sync(execute: calcs)
        DispatchQueue.main.async(execute: layouts)
        
    }
    
}
