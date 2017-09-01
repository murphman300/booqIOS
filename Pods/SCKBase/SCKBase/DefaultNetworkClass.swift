//
//  DefaultNetworkClass.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-19.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//
import Foundation

public enum NetworkOperationError: Error {
    case error, noData, noConnection
}

public enum NetworkOperationParsingError: Error {
    case noCode, noMessage, noPayload
}

open class DefaultNetwork: NSObject {
    
    static public let operation = DefaultNetwork()
    
    override public init() {
        super.init()
    }
    
    public func perform(request: NSMutableURLRequest,_ completion: @escaping(_ code: Int,_ message: String,_ body: [String:Any],_ other: Any?,_ array: [AnyObject]?) -> Void,_ failure: @escaping(_ reason: String) -> Void) {
        URLSession.shared.dataTask(with: request as URLRequest) { (d, resp, err) in
            do {
                try self.urlSessionResponseParser(data: d, response: resp, error: err, { (c, m, b, o, a) in
                    if let bo = b {
                        guard let ot = o else {
                            completion(c, m, bo, nil, nil)
                            return
                        }
                        completion(c, m, bo, ot, nil)
                    } else if let arr = a {
                        completion(c, m, [:], nil, arr)
                    } else {
                        if let ot = o {
                            completion(c, m, [:], ot, nil)
                        } else {
                            completion(c, m, [:], nil, nil)
                        }
                    }
                })
            } catch let err {
                failure(err.localizedDescription)
            }
            }.resume()
    }
    
    public func performRequestOn(url: URL,_ completion: @escaping(_ code: Int,_ message: String,_ body: [String:Any],_ other: Any?,_ array: [AnyObject]?) -> Void,_ failure: @escaping(_ reason: String) -> Void) {
        URLSession.shared.dataTask(with: url) { (d, resp, err) in
            do {
                try self.urlSessionResponseParser(data: d, response: resp, error: err, { (c, m, b, o, a) in
                    if let bo = b {
                        guard let ot = o else {
                            completion(c, m, bo, nil, nil)
                            return
                        }
                        completion(c, m, bo, ot, nil)
                    } else if let arr = a {
                        completion(c, m, [:], nil, arr)
                    } else {
                        if let ot = o {
                            completion(c, m, [:], ot, nil)
                        } else {
                            completion(c, m, [:], nil, nil)
                        }
                    }
                })
            } catch let err {
                failure(err.localizedDescription)
            }
            }.resume()
    }
    
    public func performRequestForData(url: URL,_ completion: @escaping(_ code: Int,_ message: String,_ data: Data) -> Void,_ failure: @escaping(_ reason: String) -> Void) {
        URLSession.shared.dataTask(with: url) { (d, resp, err) in
            self.urlDataTaskResponseHandlerFor(data: d, { (p) in
                completion(200, "Ok", p)
            }, { (a) in
                failure(a)
            })
            }.resume()
    }
    
    public func urlDataTaskResponseHandlerFor(data: Data?, _ present: @escaping(_ present: Data) -> Void,_ absent: @escaping(_ reason: String) -> Void) {
        guard let d = data else {
            return absent("no data")
        }
        present(d)
    }
    
    public func urlSessionResponseParser(data: Data?, response : URLResponse?, error : Error?,_ completion: @escaping(_ code: Int,_ message: String,_ body: [String:Any]?,_ other: Any?,_ bodyArray: [AnyObject]?) -> Void) throws {
        if response == nil && data == nil {
            throw NetworkOperationError.noConnection
        }
        if error != nil {
            throw NetworkOperationError.error
        }
        if data == nil {
            throw NetworkOperationError.noData
        }
        if let d = data {
            do {
                guard let object = try JSONSerialization.jsonObject(with: d, options: .mutableLeaves) as? [String:Any] else {
                    throw NetworkOperationParsingError.noPayload
                }
                if let code = object["resultCode"] as? Int {
                    if let message = object["message"] as? String {
                        if let t = object["result"] as? [String:Any] {
                            completion(code, message, t, nil, nil)
                        } else if let t = object["result"] as? [AnyObject] {
                            completion(code, message, nil, nil, t)
                        } else {
                            completion(code, message, nil, nil, nil)
                        }
                    } else {
                        throw NetworkOperationParsingError.noMessage
                    }
                } else {
                    throw NetworkOperationParsingError.noCode
                }
            } catch {
                throw NetworkOperationParsingError.noPayload
            }
        }
    }
    
    public func facebookedRequest(token: String, method: httpMet, payload: [String: Any]?) {
        
        
    }
    
    public func facebookLogin(token: String, device: String,_ completion: @escaping (_ new: String?)->Void) {
        do {
            let req = try DefaultRequest(facebookRefresh: token, email: "", device: device)
            self.perform(request: req, { (code, message, body, other, arr) in
                guard code == 200 else {
                    print("Failed Facebook Login : " + message)
                    completion(nil)
                    return
                }
                guard let new = body["result"] as? String else {
                    completion(nil)
                    return
                }
                completion(new)
            }, { (reason) in
                print("Failed Facebook Login : " + reason)
                completion(nil)
            })
        } catch {
            completion(nil)
        }
    }
    
    public func loginFacebookForRefresh(token: String, email: String, device: String,_ completion: @escaping (_ new: String?,_ body: [String:Any]?)->Void) {
        do {
            let req = try DefaultRequest(facebookRefresh: token, email: email, device: device)
            self.perform(request: req, { (code, message, body, other, arr) in
                guard code == 200 else {
                    print("Failed Facebook Login : " + message)
                    completion(nil, nil)
                    return
                }
                guard let new = body["token"] as? String else {
                    completion(nil, nil)
                    return
                }
                completion(new, body)
            }, { (reason) in
                print("Failed Facebook Login : " + reason)
                completion(nil, nil)
            })
        } catch {
            completion(nil, nil)
        }
    }
}

