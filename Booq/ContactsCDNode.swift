//
//  ContactsCDNode.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-14.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import CoreData

var hold : Bool = false

extension ImageCache {
    
    
    func fetchURLs(_ urls: [ProfilePicObject],_ completion: @escaping ([ProfilePicObject])->Bool) -> Bool {
        let storedError: NSError?
        let downloadGroup = DispatchGroup()
        let addresses = urls
        var obs : [ProfilePicObject] = []
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: addresses.count) {
            i in
            let index = Int(i)
            let address = addresses[index]
            if let add = address.url, let url = URL(string: add) {
                downloadGroup.enter()
                DefaultNetwork.operation.performRequestForData(url: url, { (code, message, d) in
                    guard let imageToCache = UIImage(data: d) else {
                        print("CDN IMG FAIL ERROR: failed to generate uiimage from \(address)")
                        downloadGroup.leave()
                        return
                    }
                    ImageCache.main.applyProfilePic(imageToCache, add, address.id, { (ob) in
                        obs.append(ob)
                    })
                    downloadGroup.leave()
                }) { (reason) in
                    print("CDN IMG FAIL ERROR: failed to fetch image at \(address)")
                    downloadGroup.leave()
                }
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            hold = completion(obs)
        }
        while hold == false {
            print("holding")
        }
        return hold
    }
    
}


class ContactsCD {
    
    static let node = ContactsCD()
    
    init() {
        
    }
    
    func configure() -> Bool {
        do {
            let request: NSFetchRequest<ContactProfile> = ContactProfile.fetchRequest()
            let records = try CoreDataManager.node.managedObjectContext.fetch(request) as [ContactProfile]
            guard !records.isEmpty else {
                return false
            }
            for cont in records {
                if let contact = cont.toContact() {
                    ContactsCache.pipe.contacts.append(contact)
                }
            }
            let current = ContactsCache.pipe.contacts
            ContactsCache.pipe.syncContactsWithCache(current)
            return true
        } catch {
            print("Error fetching new data")
            return false
        }
    }
    
    func configureInitial() -> Bool {
        for item in ContactsCache.pipe.contacts {
            let new = ContactProfile(context: CoreDataManager.node.managedObjectContext)
            if new.upDateFromNew(item) {
                new.willSave()
                CoreDataManager.node.managedObjectContext.insert(new)
            } else {
                print("Failed new object for initial")
            }
        }
        CoreDataManager.node.saveData()
        App.defaults.configured = true
        return true
    }
    
    func createContact(_ contact: Contact,_ image: UIImage, url: String?, id: String?,_ completion: @escaping(()->())) {
        PictureManager.pipe.addPicture(image, url, id) { (object) in
            let cont = contact
            cont.picUrl = object.id
            self.add(contact, {
                completion()
            })
        }
    }
    
    func createContactFromInitial(_ contact: Contact,_ completion: @escaping(()->())) {
        PictureManager.pipe.addInitialPicture(url: contact.picUrl!) { (ob) in
            guard let object = ob else {
                completion()
                return
            }
            let cont = contact
            cont.picUrl = object.id
            self.add(contact, {
                completion()
            })
        }
    }
    
    func createContact(_ contact: Contact,_ image: ProfilePicObject,_ completion: @escaping(()->())) {
        let cont = contact
        cont.picUrl = image.id
        self.add(contact, {
            completion()
        })
    }
    
    func add(_ contact: Contact) {
        cdSave(contact)
    }
    
    func delete(_ contact: Contact) {
        remove(contact)
    }
    
    func add(_ contact: Contact,_ completion: @escaping(()->())) {
        cdSave(contact, completion)
    }
    
    func update(_ contact: Contact,_ completion: @escaping(()->())) {
        cdSave(contact, completion)
    }
    
    func delete(_ contact: Contact,_ completion: @escaping(()->())) {
        remove(contact, completion)
    }
    
    private func cdSave(_ image: Contact) {
        do {
            let request: NSFetchRequest<ContactProfile> = ContactProfile.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", image.id)
            CoreDataManager.node.fetchSync(request, { (records) in
                guard let first = records.first else {
                    let new = ContactProfile(context: CoreDataManager.node.managedObjectContext)
                    if new.checkUpdateFrom(image) {
                        new.willSave()
                        CoreDataManager.node.performOnThreadSync {
                            CoreDataManager.node.managedObjectContext.insert(new)
                        }
                        CoreDataManager.node.saveData()
                    }
                    return
                }
                if first.checkUpdateFrom(image) {
                    CoreDataManager.node.saveData()
                }
            })
        } catch let err {
            print("Something Went Wrong while saving new item : \(err.localizedDescription)")
        }
    }
    
    private func cdSave(_ image: Contact,_ completion: @escaping(()->())) {
        do {
            let request: NSFetchRequest<ContactProfile> = ContactProfile.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", image.id)
            CoreDataManager.node.fetchSync(request, { (records) in
                guard let first = records.first else {
                    let new = ContactProfile(context: CoreDataManager.node.managedObjectContext)
                    if new.upDateFromNew(image) {
                        new.willSave()
                        CoreDataManager.node.performOnThreadSync {
                            CoreDataManager.node.managedObjectContext.insert(new)
                            CoreDataManager.node.saveData({ 
                                completion()
                            }, { (reason) in
                                print(reason)
                                completion()
                            })
                        }
                        return
                    } else {
                        completion()
                    }
                    return
                }
                if first.checkUpdateFrom(image) {
                    CoreDataManager.node.saveData({
                        completion()
                    }, { (reason) in
                        print(reason)
                        completion()
                    })
                }
            })
        } catch let err {
            print("Something Went Wrong while saving new item : \(err.localizedDescription)")
        }
    }
    
    private func remove(_ image: Contact) {
        do {
            let request: NSFetchRequest<ContactProfile> = ContactProfile.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", image.id)
            let records = try CoreDataManager.node.managedObjectContext.fetch(request) as [ContactProfile]
            guard let first = records.first else {
                return
            }
            CoreDataManager.node.managedObjectContext.delete(first)
            CoreDataManager.node.saveData()
        } catch let err {
            print("Something Went Wrong while deleting item : \(err.localizedDescription)")
        }
    }
    
    private func remove(_ image: Contact,_ completion: @escaping(()->())) {
        do {
            let request: NSFetchRequest<ContactProfile> = ContactProfile.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", image.id)
            CoreDataManager.node.fetchAsync(request, { (records) in
                guard let first = records.first else {
                    completion()
                    return
                }
                CoreDataManager.node.managedObjectContext.delete(first)
                CoreDataManager.node.saveData({
                    completion()
                }, { (reason) in
                    print(reason)
                    completion()
                })
            })
        } catch let err {
            print("Something Went Wrong while deleting item : \(err.localizedDescription)")
        }
    }
}
