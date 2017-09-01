//
//  FirebaseManager.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-15.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import SCKBase

fileprivate let firebaseDatabase = "https://portfolios-6de4e.firebaseio.com/"

class FirebaseManager {
    
    let reference = Database.database().reference(fromURL: firebaseDatabase).child("main")
    
    private let storage = Storage.storage().reference()

    static let node = FirebaseManager()
    
    private var established : Bool = false
    
    func configure() {
        
    }
    
    func getAllInitial(_ completion: @escaping(([Contact])->()),_ failure: (()->())?) {
        var res : (()->Bool)?
        self.reference.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dict = snapshot.value, let objects = dict as? [String:[String:Any]] {
                if !objects.isEmpty {
                    var contacts : [Contact] = []
                    for (_, value) in objects.enumerated() {
                        var val = value.value
                        val["id"] = value.key
                        do {
                            let con = try Contact(from: val)
                            contacts.append(con)
                        } catch {
                            print("Failed to cast initial contact from \(value.key)")
                        }
                    }
                    completion(contacts)
                } else {
                    failure?()
                }
            } else {
                failure?()
            }
        }, withCancel: nil)
    }
    
    func updateValue(_ id: String,_ with: [String:Any]) {
        reference.child(id).updateChildValues(with) { (err, ref) in
            if err != nil {
                print("Failed to update \(id)")
            } else {
                print("Updated value")
            }
        }
    }
    
    func updateValue(_ id: String,_ with: [String:Any],_ completion: (()->())?) {
        reference.child(id).updateChildValues(with) { (err, ref) in
            if err != nil {
                print("Failed to update \(id)")
                completion?()
            } else {
                print("Successfully updated child node")
                completion?()
            }
        }
    }
    func addNew(_ with: [String:Any],_ completion: ((String?)->())?) {
        guard let id = with["id"] as? String else {
            completion?(nil)
            return
        }
        let new = reference.child(id)
        new.updateChildValues(with) { (err, ref) in
            if err != nil {
                print("Failed to update \(new.key)")
                completion?(nil)
            } else {
                completion?(new.key)
            }
        }
    }
    
    func updateElement(_ value: String,_ of: String,_ with: Any?) {
        reference.child(of).child(value).setValue(with, andPriority: nil)
    }
    
    func get(_ contact: String,_ completion: @escaping((Contact?)->())) {
        reference.child(contact).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dict = snapshot.value, let objects = dict as? [String:[String:Any]] {
                if !objects.isEmpty {
                    var contacts : [Contact] = []
                    for (_, value) in objects.enumerated() {
                        var val = value.value
                        val["id"] = value.key
                        do {
                            let con = try Contact(from: val)
                            contacts.append(con)
                        } catch {
                            print("Failed to cast initial contact from \(value.key)")
                        }
                    }
                    if let first = contacts.first {
                        completion(first)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }, withCancel: nil)
    }
    
    func new(_ contact: Contact,_ image: UIImage?,_ completion: @escaping((Contact?)->())) {
        if let im = image {
            guard let data : Data = UIImageJPEGRepresentation(im, 1.0) else {
                completion(nil)
                return
            }
            let id = UUID.init().uuidString
            let path = storage.child("booq/contactpics/\(id).jpg")
            path.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print(String(describing: error!))
                    completion(nil)
                    return
                }
                if let downloaded = metadata.downloadURL(){
                    let cont = contact
                    cont.picUrl = downloaded.absoluteString
                    cont.picID = id
                    self.addNew(cont.object, { (newId) in
                        if newId == nil {
                            completion(nil)
                            return
                        }
                        completion(cont)
                    })
                } else {
                    print(String(describing: error!))
                    completion(nil)
                }
            }
        } else {
            self.updateValue(contact.id, contact.object, {
                completion(contact)
            })
        }
    }
    
    func update(_ contact: Contact,_ image: UIImage?, newImage: Bool,_ completion: @escaping((Contact?)->())) {
        if let im = image {
            guard let data : Data = UIImageJPEGRepresentation(im, 1.0) else {
                completion(nil)
                return
            }
            if contact.picUrl != nil {
                if newImage, let picid = contact.picID {
                    let deletePath = storage.child("booq/contactpics/\(picid).jpg")
                    deletePath.delete(completion: { (err) in
                        if err != nil {
                            completion(nil)
                        } else {
                            let id = UUID.init().uuidString
                            let path = self.storage.child("booq/contactpics/\(id).jpg")
                            path.putData(data, metadata: nil) { (metadata, error) in
                                guard let metadata = metadata else {
                                    print(String(describing: error!))
                                    completion(nil)
                                    return
                                }
                                if let downloaded = metadata.downloadURL(){
                                    let cont = contact
                                    cont.picUrl = downloaded.absoluteString
                                    cont.picID = id
                                    self.updateValue(contact.id, contact.object, {
                                        completion(cont)
                                    })
                                } else {
                                    completion(nil)
                                }
                            }
                        }
                    })
                } else {
                    self.updateValue(contact.id, contact.object, {
                        completion(contact)
                    })
                }
            } else {
                let id = UUID.init().uuidString
                let path = storage.child("booq/contactpics/\(id).jpg")
                path.putData(data, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        print(String(describing: error!))
                        completion(nil)
                        return
                    }
                    if let downloaded = metadata.downloadURL(){
                        let cont = contact
                        cont.picUrl = downloaded.absoluteString
                        self.updateValue(contact.id, contact.object, {
                            completion(cont)
                        })
                    } else {
                        print(String(describing: error!))
                        completion(nil)
                    }
                }
            }
        } else {
            self.updateValue(contact.id, contact.object, {
                completion(contact)
            })
        }
    }
    
    func delete(_ contact: Contact,_ completion: @escaping((Error?)->())) {
        if let picid = contact.picID {
            let path = storage.child("booq/contactpics/\(picid).jpg")
            path.delete(completion: { (err) in
                if let er = err {
                    print(er.localizedDescription)
                } else {
                    print("")
                }
            })
        }
        reference.child(contact.id).removeValue { (err, newRef) in
            completion(err)
        }
    }

}

enum ContactParameter {
    
    case name, last, corp, title, email, dob, phone, zip, pic
    
}

class EditContactNode {
    
    var original : Contact?
    
    var new : Contact?
    
    private var newPic: Bool = false
    
    init(original: Contact) {
        self.original = original
    }
    
    func update(_ param: ContactParameter,_ value: String) {
        if new == nil, let c = original {
            new = Contact(contact: c)
        }
        switch param {
        case .name :
            new?.name = value
        case .last :
            new?.lastName = value
        case .corp :
            new?.company = value
        case .title :
            new?.jobTitle = value
        case .email :
            new?.email = value
        case .dob :
            let d = DOB()
            if let da = Date().dateFrom(string: value) {
                d.date = da
                new?.dob = d
            }
        case .phone :
            do {
                new?.phone = try PhoneNumber(number: value)
            } catch {
            
            }
        case .zip:
            new?.postalCode = value
        case .pic:
            newPic = value == "new"
        }
    }
    
    func newPicString() -> Bool {
        return newPic
    }
    
    func resulting() -> Contact? {
        return new
    }
    
}

extension Contact {
    
    var object : [String:Any] {
        get {
            var obj : [String:Any] = [:]
            obj["id"] = self.id
            obj["name"] = self.name
            if let n = self.lastName {
                obj["lastname"] = n
            }
            if let n = self.picUrl {
                obj["picurl"] = n
            }
            if let n = self.email {
                obj["email"] = n
            }
            if let n = self.phone {
                obj["phone"] = n.compact
            }
            if let pici = self.picID {
                obj["picID"] = pici
            }
            if let pc = self.postalCode {
                obj["postalcode"] = pc
            }
            obj["company"] = self.company
            obj["jobtitle"] = self.jobTitle
            return obj
        }
    }
    
}
