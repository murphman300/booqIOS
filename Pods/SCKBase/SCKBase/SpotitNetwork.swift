//
//  SpotitNetwork.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-19.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

open class SpotitNetwork: DefaultNetwork {
    
    open func performJSON(request: NSMutableURLRequest,_ completion: @escaping(_ code: Int,_ message: String,_ body: JSON,_ other: Any?,_ array: [JSON]?) -> Void,_ failure: @escaping(_ reason: String) -> Void) {
        URLSession.shared.dataTask(with: request as URLRequest) { (d, resp, err) in
            do {
                let ob = try JSONObject(object: [:])
                try self.urlSessionResponseJSONParser(data: d, response: resp, error: err, { (c, m, b, o, a) in
                    if let bo = b {
                        guard let ot = o else {
                            completion(c, m, bo, nil, nil)
                            return
                        }
                        completion(c, m, bo, ot, nil)
                    } else if let arr = a {
                        completion(c, m, ob.json, nil, arr)
                    } else {
                        if let ot = o {
                            completion(c, m, ob.json, ot, nil)
                        } else {
                            completion(c, m, ob.json, nil, nil)
                        }
                    }
                })
            } catch let err {
                failure(err.localizedDescription)
            }
        }.resume()
    }
    
    open func performJSONRequestOn(url: URL,_ completion: @escaping(_ code: Int,_ message: String,_ body: JSON,_ other: Any?,_ array: [JSON]?) -> Void,_ failure: @escaping(_ reason: String) -> Void) {
        URLSession.shared.dataTask(with: url) { (d, resp, err) in
            do {
                let ob = try JSONObject(object: [:])
                try self.urlSessionResponseJSONParser(data: d, response: resp, error: err, { (c, m, b, o, a) in
                    if let bo = b {
                        guard let ot = o else {
                            completion(c, m, bo, nil, nil)
                            return
                        }
                        completion(c, m, bo, ot, nil)
                    } else if let arr = a {
                        completion(c, m, ob.json, nil, arr)
                    } else {
                        if let ot = o {
                            completion(c, m, ob.json, ot, nil)
                        } else {
                            completion(c, m, ob.json, nil, nil)
                        }
                    }
                })
            } catch let err {
                failure(err.localizedDescription)
            }
        }.resume()
    }
    /*
     func performRequestForData(url: URL,_ completion: @escaping(_ code: Int,_ message: String,_ data: Data) -> Void,_ failure: @escaping(_ reason: String) -> Void) {
     URLSession.shared.dataTask(with: url) { (d, resp, err) in
     self.urlDataTaskResponseHandlerFor(data: d, { (p) in
     completion(200, "Ok", p)
     }, { (a) in
     failure(a)
     })
     }.resume()
     }
     
     func urlDataTaskResponseHandlerFor(data: Data?, _ present: @escaping(_ present: Data) -> Void,_ absent: @escaping(_ reason: String) -> Void) {
     guard let d = data else {
     return absent("no data")
     }
     present(d)
     }*/
    
    open func urlSessionResponseJSONParser(data: Data?, response : URLResponse?, error : Error?,_ completion: @escaping(_ code: Int,_ message: String,_ body: JSON?,_ other: Any?,_ bodyArray: [JSON]?) -> Void) throws {
        
        if response == nil {
            throw NetworkOperationError.noConnection
        }
        if error != nil {
            throw NetworkOperationError.error
        }
        if data == nil {
            throw NetworkOperationError.noData
        }
        if let d = data {
            let object = JSON(data: d)
            if let code = object["resultCode"].int {
                if let message = object["message"].string {
                    if object["result"].exists() {
                        do {
                            let raw = try object["result"].rawData()
                            if let ob = object["result"].dictionaryObject {
                                do {
                                    let o = try JSONObject(object: ob)
                                    completion(code, message, o.json, nil, nil)
                                } catch let err {
                                    throw err
                                }
                            } else if let ob = object["result"].array {
                                completion(code, message, nil, nil, ob)
                            } else {
                                throw NetworkOperationParsingError.noPayload
                            }
                        } catch let err {
                            throw err
                        }
                    } else {
                        completion(code, message, nil, nil, nil)
                    }
                } else {
                    throw NetworkOperationParsingError.noMessage
                }
            } else {
                throw NetworkOperationParsingError.noCode
            }
        }
    }
}
