//
//  HTMLView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-30.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import WebKit


class HTMLView : SelectorView, WKNavigationDelegate {
    
    var path : String? {
        didSet {
            if let l = path {
                parseLicencse(l)
            }
        }
    }
    
    var image : ImageView = {
        var v = ImageView(secondaries: false, cornerRadius: 0.0)
        return v
    }()
    
    var loader : UIView = {
        var v = UIView()
        v.backgroundColor = colors.purplishColor
        return v
    }()
    
    var content : WKWebView = {
        var v = WKWebView()
        v.isUserInteractionEnabled = true
        return v
    }()
    
    override func set(_ frame: CGRect) {
        backgroundColor = .clear
        addSubview(content)
        content.addSubview(loader)
        content.navigationDelegate = self
        content.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        loader.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        super.set(frame)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.25) {
            self.loader.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.75, height: 3)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.loader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 3)
        }) { (v) in
            self.loader.alpha = 0
        }
    }
    
    func parseLicencse(_ l : String) {
        do {
            guard let filePath = Bundle.main.path(forResource: l, ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            content.loadHTMLString(contents, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
    }
    
}
