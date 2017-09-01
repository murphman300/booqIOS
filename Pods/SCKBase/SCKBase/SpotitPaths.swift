//
//  SpotitPaths.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit



public struct LocalPaths {
    
    private static let local : String = "192.168.0.20:3000/api"
    public struct users {
        private static let root : String = local + "/users"
        public struct login {
            public static let facebook : String = root + "/facebooklogin"
        }
        public struct create {
            public static let facebookFinal : String = root + "/facebookfinal"
        }
        public struct cell {
            private static let croot : String = root + "/cell"
            public static let confirm : String = croot + "/confirm"
            public static let auth : String = croot + "/auth"
        }
        public struct wallet {
            private static let croot : String = root + "/wallet"
            public static let get : String = croot + "/methods"
            public struct methods {
                private static let mroot : String = local + "/method"
                public static let update : String = mroot + "/update"
                public static let delete : String = mroot + "/delete"
                public static let add : String = mroot + "/add"
            }
        }
        public static let get : String = root + "/profile"
    }
    public struct payment {
        private static let proot : String = Connections.node.paymentRoot
        public struct charge {
            private static let croot : String = proot + "/process"
            public static let create : String = croot + "/charge"
            
        }
    }
    public struct merchants {
        private static let root : String = local + "/merchant"
        public struct create {
            private static let croot : String = root + "/create"
            public static let initial : String = croot + "/initial"
            public static let initialUpdate : String = croot + "/initialupdate"
            public struct owner {
                private static let oroot : String = croot + "/owner"
                public static let link : String = oroot + "/link"
                public static let contact : String = oroot + "/contact"
                public static let linkAuth : String = oroot + "/linkauth"
                public static let address : String = oroot + "/address"
            }
            public static let connect : String = croot + "/connect"
            public static let kyc : String = croot + "/upload/kyc"
            public static let uploadToken : String = croot + "/wallet/sendtoken"
            public static let tosFinal : String = croot + "/tos/final"
        }
        
        public struct check {
            private static let croot : String = root + "/check"
            public static let transfers : String = croot + "/transfers"
            
            
        }
        public struct profile {
            private static let croot : String = root + "/profile"
            public static let value : String = croot
            
        }
        public struct authenticate {
            private static let croot : String = root + "/authenticate"
            public static let value : String = croot
            
        }
        public struct locations {
            private static let croot : String = root + "/locations"
            public static let add : String = croot + "/add"
            
            
        }
    }
    public struct location {
        private static let lroot : String = local + "/locations"
        public struct payment {
            private static let croot : String = lroot + "/payment"
            public static let request : String = croot + "/resquest"
        }
        public struct process {
            private static let croot : String = lroot + "/process"
            public static let request : String = croot + "/payment"
        }
        public struct info {
            private static let croot : String = lroot + "/info"
            public static let address : String = croot + "/address"
            public static let profile : String = croot + "/profile"
        }
        public struct team {
            private static let croot : String = lroot + "/employees"
            public static let managers : String = croot + "/managers"
            public static let admins : String = croot + "/admins"
            public static let all : String = croot + ""
        }
        public struct devices {
            private static let croot : String = lroot + "/devices"
            public static let add : String = croot + "/add"
            public static let reasign : String = croot + "/reasign"
        }
    }
}

class EndPoint: Equatable {
    
    private var path = String() {
        didSet {
            if let u = URL(string: path) {
                url = u
            }
        }
    }
    
    private var url : URL?
    
    init(string: String) {
        self.path = string
    }
    
    static func !=(_ lhs: EndPoint,_ rhs: EndPoint) -> Bool {
        return lhs.path != rhs.path
    }
    static func ==(_ lhs: EndPoint,_ rhs: EndPoint) -> Bool {
        return lhs.path == rhs.path
    }
}

enum SpotitP {
    
    enum users : String {
        case auth
        case login
        case create
        case cell
        enum wallet {
            enum methods {
                
            }
        }
    }
    
    enum location {
        
    }
}


public struct SpotitPaths {
    
    private static let local : String = Connections.node.root
    public struct users {
        private static let root : String = local + "/users"
        public struct login {
            public static let facebook : String = root + "/facebooklogin"
        }
        public struct auth {
            public static let refresh : String = root + "/login/refresh"
        }
        public struct create {
            public static let facebookFinal : String = root + "/facebookfinal"
        }
        public struct cell {
            private static let croot : String = root + "/cell"
            public static let confirm : String = croot + "/confirm"
            public static let auth : String = croot + "/auth"
        }
        public struct wallet {
            private static let croot : String = root + "/wallet"
            public static let get : String = croot + "/get"
            public struct methods {
                private static let mroot : String = local + "/wallet" + "/method"
                public static let update : String = mroot + "/update"
                public static let delete : String = mroot + "/delete"
                public static let add : String = mroot + "/add"
            }
        }
        public static let get : String = root + "/profile"
        public static let updateBulk : String = root + "/update/bulk"
    }
    public struct payment {
        private static let proot : String = Connections.node.paymentRoot
        public struct charge {
            private static let croot : String = proot + "/process"
            public static let create : String = croot + "/charge"
            
        }
    }
    public struct merchants {
        private static let root : String = local + "/merchant"
        public struct create {
            private static let croot : String = root + "/create"
            public static let initial : String = croot + "/initial"
            public static let initialUpdate : String = croot + "/initialupdate"
            public struct owner {
                private static let oroot : String = croot + "/owner"
                public static let link : String = oroot + "/link"
                public static let contact : String = oroot + "/contact"
                public static let linkAuth : String = oroot + "/linkauth"
                public static let address : String = oroot + "/address"
            }
            public static let connect : String = croot + "/connect"
            public static let kyc : String = croot + "/upload/kyc"
            public static let uploadToken : String = croot + "/wallet/sendtoken"
            public static let tosFinal : String = croot + "/tos/final"
        }
        
        public struct check {
            private static let croot : String = root + "/check"
            public static let transfers : String = croot + "/transfers"
            
            
        }
        public struct profile {
            private static let croot : String = root + "/profile"
            public static let value : String = croot
            
        }
        public struct authenticate {
            private static let croot : String = root + "/authenticate"
            public static let value : String = croot
            
        }
        public struct locations {
            private static let croot : String = root + "/locations"
            public static let add : String = croot + "/add"
            
            
        }
    }
    public struct location {
        private static let lroot : String = local + "/locations"
        public struct payment {
            private static let croot : String = lroot + "/payment"
            public static let request : String = croot + "/resquest"
        }
        public struct process {
            private static let croot : String = lroot + "/process"
            public static let request : String = croot + "/payment"
        }
        public struct info {
            private static let croot : String = lroot + "/info"
            public static let address : String = croot + "/address"
            public static let profile : String = croot + "/profile"
        }
        public struct team {
            private static let croot : String = lroot + "/employees"
            public static let managers : String = croot + "/managers"
            public static let admins : String = croot + "/admins"
            public static let all : String = croot + ""
        }
        public struct devices {
            private static let croot : String = lroot + "/devices"
            public static let add : String = croot + "/add"
            public static let reasign : String = croot + "/reasign"
        }
    }
}

