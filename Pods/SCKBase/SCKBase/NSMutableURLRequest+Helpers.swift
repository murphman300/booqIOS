//
//  NSMutableURLRequest+Helpers.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    
    public func formAsFB(_ method: httpMet,_ authToken: String, payload: Data?) {
        switch method {
        case .get:
            httpMethod = "GET"
        case.post :
            httpMethod = "POST"
        case .delete :
            httpMethod = "DELETE"
        }
        
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue(authToken, forHTTPHeaderField: "Authorization: Bearer ")
        addValue("@facebook", forHTTPHeaderField: "tokentype")
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func formAs(_ method: httpMet,_ authToken: String, payload: Data?) {
        switch method {
        case .get:
            httpMethod = "GET"
        case.post :
            httpMethod = "POST"
        case .delete :
            httpMethod = "DELETE"
        }
        
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue(authToken, forHTTPHeaderField: "Authorization : Bearer ")
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func formLogin(_ payload: Data?) {
        httpMethod = "POST"
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func formWithAKey(_ method: httpMet,_ authToken: String, payload: Data?) {
        switch method {
        case .get:
            httpMethod = "GET"
        case.post :
            httpMethod = "POST"
        case .delete :
            httpMethod = "DELETE"
            
            
        }
        
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue(authToken, forHTTPHeaderField: "X-APIKey")
        if payload != nil {
            httpBody = payload
        }
        
    }
    
    public func form(_ method: httpMet,_ payload: Data?) {
        switch method {
        case .get:
            httpMethod = "GET"
        case.post :
            httpMethod = "POST"
        case .delete :
            httpMethod = "DELETE"
        }
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func formDocUploadWithAKey(_ authToken: String, payload: Data?) {
        httpMethod = "PUT"
        guard let dat = payload else {
            return
        }
        let dataSize = NSData(data: dat)
        let size : Int = dataSize.length
        guard size < 5000 else {
            return
        }
        addValue("STPverification-document", forHTTPHeaderField: "Document-Type")
        addValue("\(size)", forHTTPHeaderField: "Content-Length")
        addValue(authToken, forHTTPHeaderField: "X-APIKey")
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func formBlank(_ method: httpMet, payload: Data?) {
        switch method {
        case .get:
            httpMethod = "GET"
        case.post :
            httpMethod = "POST"
        case .delete :
            httpMethod = "DELETE"
        }
        
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func deleteTransportMethod(_ token: String) {
        
        httpMethod = ""
        
    }
    
    public func transportMethod(_ method: httpMet,_ authToken: String, _ payload: Data?,_ upid: String,_ uuid: String) {
        switch method {
        case .get:
            httpMethod = "GET"
        case .post :
            httpMethod = "POST"
        case .delete :
            httpMethod = "DELETE"
            
        }
        
        
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue(authToken, forHTTPHeaderField: "Authorization: Bearer ")
        
        if payload != nil {
            httpBody = payload
        }
    }
    
    public func picUpload(_ token: String, fileName: String, payload: Data,_ completion: @escaping(_ result: Bool) -> Void) {
        
        httpMethod = "POST"
        let boundary = "Boundary - \(UUID().uuidString)"
        
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        setValue(token, forHTTPHeaderField: "X-APIKey")
        
        
        forJPEGImageUploadCreateBodyWith(parameters: nil, fileName: fileName, filePathKey: nil, imageDataKey: payload as NSData, boundary: boundary, {
            data in
            guard let da = data else {
                completion(false)
                return
            }
            
            self.httpBody = da as Data
            completion(true)
            
        })
        
        
    }
    
    public func forJPEGImageUploadCreateBodyWith(parameters: [String: String]?, fileName: String, filePathKey: String?, imageDataKey: NSData, boundary: String,_ completion: @escaping(NSData?) -> Void){
        let body = NSMutableData()
        var key = String()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        if let one = filePathKey {
            key = one
        } else {
            key = "nil"
        }
        
        let filename = "\(fileName).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        completion(body)
    }
}

