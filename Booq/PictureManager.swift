//
//  PictureManager.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-14.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import CoreData

class ProfilePicObject {
    var url : String?
    var id : String
    var image : UIImage?
    init(url: String?, id: String, image: UIImage?) {
        self.url = url
        self.id = id
        self.image = image
    }
    
    init(url: String) {
        self.url = url
        self.id = UUID.init().uuidString
    }
}

extension ProfilePic {
    
    
    func checkUpdateFrom(_ object: ProfilePicObject) -> Bool {
        guard self.id == object.id else { return false }
        self.url = object.url
        self.id = object.id
        self.picture = object.image != nil ? object.image! as NSObject : nil
        return true
    }
    
    func checkUpdateFromNew(_ object: ProfilePicObject) -> Bool {
        self.url = object.url
        self.id = object.id
        self.picture = object.image != nil ? object.image! as NSObject : nil
        return true
    }
    
    func apply(_ object: ProfilePicObject) {
        self.url = object.url
        self.id = object.id
        self.picture = object.image != nil ? object.image! as NSObject : nil
    }
    
}


extension ImageCache {
    
    func applyProfilePic(_ image: UIImage,_ url : String?,_ id: String?,_ completion: @escaping(ProfilePicObject) -> Void) {
        if let ident = id {
            if let obj = self.profilePics.object(forKey: ident as NSString) as? UIImage {
                let ob = ProfilePicObject(url: nil, id: ident, image: obj)
                completion(ob)
                PictureManager.pipe.applyObjectToManagedObject(ob)
                return
            } else {
                self.add(image, url: ident, profile: true)
                let ob = ProfilePicObject(url: nil, id: ident, image: image)
                PictureManager.pipe.applyObjectToManagedObject(ob)
            }
        }
        let id = id != nil ? id! : UUID.init().uuidString
        self.add(image, url: id, profile: true)
        let ob = ProfilePicObject(url: url, id: id, image: image)
        completion(ob)
        PictureManager.pipe.applyObjectToManagedObject(ob)
    }
    
    func add(_ image: UIImage, url: String, profile: Bool) {
        if profile {
            self.profilePics.setObject(image as NSObject, forKey: url as NSString)
        } else {
            self.locations.setObject(image as NSObject, forKey: url as NSString)
        }
    }
    
    func applyProfilePic(_ url : String,_ id: String?,_ completion: @escaping(ProfilePicObject?) -> Void) {
        if let ident = id {
            if let obj = self.profilePics.object(forKey: ident as NSString) as? UIImage {
                completion(ProfilePicObject(url: nil, id: ident, image: obj))
                return
            } else if let t = URL(string: url) {
                DefaultNetwork.operation.performRequestForData(url: t, { (code, message, d) in
                    guard let data = UIImage(data: d) else {
                        completion(nil)
                        return
                    }
                    self.applyProfilePic(data, url, ident, { (object) in
                        completion(object)
                    })
                }, { (reason) in
                    print(reason)
                    completion(nil)
                })
                return
            }
        } else if let t = URL(string: url) {
            DefaultNetwork.operation.performRequestForData(url: t, { (code, message, d) in
                guard let data = UIImage(data: d) else {
                    completion(nil)
                    return
                }
                self.applyProfilePic(data, url, nil, { (object) in
                    completion(object)
                })
            }, { (reason) in
                print(reason)
                completion(nil)
            })
            return
        } else {
            completion(nil)
        }
    }
    
    func applyProfilePic(_ pic : ProfilePic) -> Bool {
        guard let id = pic.id else { return false }
        guard let img = pic.picture, let image = img as? UIImage else { return false }
        self.profilePics.setObject(image, forKey: id as NSString)
        return true
    }
    
}


class PictureManager {
    
    
    static let pipe = PictureManager()
    
    
    func configure() {
        do {
            let request: NSFetchRequest<ProfilePic> = ProfilePic.fetchRequest()
            let records = try CoreDataManager.node.managedObjectContext.fetch(request) as [ProfilePic]
            guard !records.isEmpty else {
                return
            }
            for pic in records {
                if ImageCache.main.applyProfilePic(pic){
                    
                } else {
                    
                }
            }
        } catch {
            
        }
    }
    
    func configureOnLoad() -> Bool {
        do {
            let request: NSFetchRequest<ProfilePic> = ProfilePic.fetchRequest()
            let records = try CoreDataManager.node.managedObjectContext.fetch(request) as [ProfilePic]
            if !records.isEmpty {
                for pic in records {
                    if ImageCache.main.applyProfilePic(pic) {
                        
                    } else {
                        print("Failed to apply CD image to cache")
                    }
                }
                return true
            } else {
                print("No CD images on file after initial launch")
                return false
            }
        } catch {
            return false
        }
    }
    
    func addInitialPicture(url: String,_ completion: @escaping((ProfilePicObject?) -> ())) {
        ImageCache.main.applyProfilePic(url, nil) { (object) in
            completion(object)
        }
    }
    
    func addPicture(_ image: UIImage,_ url : String?,_ id: String?) {
        ImageCache.main.applyProfilePic(image, url, id) { (object) in
            self.applyObjectToManagedObject(object)
        }
    }
    
    func addPicture(_ image: UIImage,_ url : String?,_ id: String?,_ imageObject: @escaping((ProfilePicObject)->())) {
        ImageCache.main.applyProfilePic(image, url, id) { (object) in
            self.applyObjectToManagedObject(object)
            imageObject(object)
        }
    }
    
    func applyObjectToManagedObject(_ object: ProfilePicObject) {
        do {
            let request: NSFetchRequest<ProfilePic> = ProfilePic.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", object.id)
            let records = try CoreDataManager.node.managedObjectContext.fetch(request) as [ProfilePic]
            guard let first = records.first else {
                let new = ProfilePic(context: CoreDataManager.node.managedObjectContext)
                if new.checkUpdateFromNew(object) {
                    new.willSave()
                    CoreDataManager.node.managedObjectContext.insert(new)
                    CoreDataManager.node.saveData()
                }
                return
            }
            first.apply(object)
            CoreDataManager.node.saveData()
        } catch {
            print("Failed to search for previously applied image")
        }
    }
    
    func applyObjectToManagedObjectAsync(_ object: ProfilePicObject,_ completion: @escaping(()->())) {
        do {
            let request: NSFetchRequest<ProfilePic> = ProfilePic.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", object.id)
            CoreDataManager.node.fetchAsync(request, { (records) in
                guard let first = records.first else {
                    let new = ProfilePic(context: CoreDataManager.node.managedObjectContext)
                    if new.checkUpdateFrom(object) {
                        new.willSave()
                        CoreDataManager.node.managedObjectContext.insert(new)
                        CoreDataManager.node.saveData()
                    }
                    return
                }
                first.apply(object)
                CoreDataManager.node.saveData()
            })
        } catch {
            
        }
    }
    
    private func uploadInternals(_ internals: [ProfilePic],_ completion: (()->())?) {
        
        var storedError: NSError?
        let downloadGroup = DispatchGroup()
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: internals.count) {
            i in
            let index = Int(i)
            let address = internals[index]
            
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion?()
        }
    }
    
}

