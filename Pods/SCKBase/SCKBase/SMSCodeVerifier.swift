//
//  SMSCodeVerifier.swift
//  SCKBase
//
//  Created by Jean-Louis Murphy on 2017-05-22.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//


import UIKit

@objc public protocol CodeVerifierDelegate : class {
    
    func code(verifier: SMSCodeVerifier, confirmation: Bool)
    func code(verifier: SMSCodeVerifier, didCancel: Bool)
    
    
}

open class SMSCodeVerifier : UIView, UITextFieldDelegate {
    
    public weak var delegate : CodeVerifierDelegate?
    
    private var token : String?
    
    private var top = CGFloat()
    
    
    private var card : UIView = {
        var v = UIView()
        v.backgroundColor = colors.lineColor
        v.alpha = 1
        return v
    }()
    
    private let number : UITextField = {
        
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.backgroundColor = UIColor.clear
        tf.textColor = colors.lineColor.withAlphaComponent(0.8)
        tf.font = fonts.checkoutMerchBold
        tf.attributedPlaceholder = NSAttributedString(string: "Code", attributes: [NSForegroundColorAttributeName: colors.lineColor.withAlphaComponent(0.5)])
        tf.textAlignment = .center
        return tf
    }()
    
    
    lazy private var plusLab : UILabel = {
        var lab = UILabel()
        lab.text = ""
        lab.font = fonts.secButtonBold
        lab.alpha = 1
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.textColor = colors.lineColor
        return lab
    }()
    
    lazy private var error : UILabel = {
        var lab = UILabel()
        lab.text = ""
        lab.font = fonts.checkoutMerchBold
        lab.alpha = 1
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.textColor = colors.lineColor
        return lab
    }()
    
    lazy private var confirm : UIButton = {
        let but = UIButton()
        but.setTitle("Send", for: .normal)
        but.titleLabel?.font = fonts.secButtonBold
        but.setTitleColor(colors.loginTfBack, for: .normal)
        but.setTitleColor(colors.purplishColor, for: .highlighted)
        but.addTarget(self, action: #selector(send), for: UIControlEvents.touchUpInside)
        return but
    }()
    
    lazy private var cancel : UIButton = {
        let but = UIButton()
        but.backgroundColor = UIColor.clear
        but.setTitle("Cancel", for: .normal)
        but.titleLabel?.font = fonts.secButton
        but.setTitleColor(colors.loginTfBack, for: .normal)
        but.setTitleColor(colors.lineColor, for: .highlighted)
        but.titleLabel?.textAlignment = .center
        but.addTarget(self, action: #selector(cancelDismiss), for: UIControlEvents.touchUpInside)
        return but
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    public func set(topPad : CGFloat) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self)
        }
        top = topPad
        self.addSubview(card)
        card.frame.size = CGSize(width: loginSizes.signUp.subScroll.width * 0.9, height: loginSizes.signUp.subScroll.height * 0.35)
        
        card.center.x = self.frame.width / 2
        card.center.y = self.frame.maxY + (card.frame.height / 2)
        card.contrastBackGround(.bottomLeft, colors.loginTfBack.withAlphaComponent(0.85), colors.loginTfBack.withAlphaComponent(0.85), [0.01, 0.99])
        
        card.addSubview(plusLab)
        card.addSubview(number)
        card.addSubview(error)
        card.addSubview(confirm)
        addSubview(cancel)
        
        plusLab.frame.size = CGSize(width: card.frame.width * 0.9, height: buttonSizes.mainheight)
        plusLab.center.x = card.frame.width / 2
        plusLab.center.y = (plusLab.frame.height / 2) + buttonSizes.tfPadding
        
        confirm.frame.size = CGSize(width: plusLab.frame.width, height: buttonSizes.mainheight)
        confirm.center.x = card.frame.width / 2
        confirm.center.y = (card.frame.height) - (card.frame.width * 0.05) - (buttonSizes.mainheight * 0.5)
        confirm.contrastBackGround(.topLeft, colors.purplishColor, colors.lightBlueMainColor, [0.01, 0.99])
        confirm.sideCircleView(nil)
        
        number.frame.size = CGSize(width: card.frame.width * 0.8, height: buttonSizes.mainheight * 1.3)
        number.center.x = card.frame.width / 2
        number.center.y = confirm.frame.minY / 2
        number.delegate = self
        let v = UIView()
        number.addSubview(v)
        v.backgroundColor = colors.lineColor.withAlphaComponent(0.6)//colors.purplishColor
        v.frame = CGRect(x: 0, y: number.frame.height - 1.5, width: number.frame.width, height: 2.5)
        v.layer.cornerRadius = 1
        
        error.frame.size = CGSize(width: plusLab.frame.width, height: buttonSizes.mainheight)
        error.center.x = card.frame.width / 2
        error.center.y = (number.frame.maxY) + buttonSizes.tfPadding + (buttonSizes.mainheight * 0.5)
        
        cancel.frame.size = CGSize(width: plusLab.frame.width, height: buttonSizes.mainheight)
        cancel.center.x = self.frame.width / 2
        cancel.center.y = self.frame.height + (card.frame.height) + buttonSizes.tfPadding + (buttonSizes.mainheight * 0.5)
        
        self.card.layer.cornerRadius = buttonSizes.mainheight / 2
        self.card.layer.masksToBounds = true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField != number else {
            guard let t = textField.text else {
                return true
            }
            guard !string.isEmpty else {
                return true
            }
            guard t.characters.count + string.characters.count  + 1 >= 14 else {
                if t.characters.count <= 11 {
                    if (t.characters.count % 2) == 0 {
                        
                        textField.text = "\(t)\(string)"
                    } else {
                        textField.text = "\(t) \(string)"
                    }
                }
                return false
            }
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    public func bringUp(token: String, _ completion: @escaping (Bool) -> Void) {
        self.token = token
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.alpha = 1
        }, completion: {
            value in
        })
        self.number.becomeFirstResponder()
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.card.center.y = self.top + (self.card.frame.height / 2)
            self.cancel.center.y = self.top + (self.card.frame.height) + buttonSizes.tfPadding + (buttonSizes.mainheight * 0.5)
        }, completion: {
            value in
            completion(true)
        })
    }
    
    private func dismiss(_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.number.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.card.center.y = self.frame.height + (self.card.frame.height / 2)
            self.cancel.center.y = self.frame.height + (self.card.frame.height) + buttonSizes.tfPadding + (buttonSizes.mainheight * 0.5)
        }, completion: {
            value in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.alpha = 0
            }, completion: {
                value in
                completion(true)
            })
        })
    }
    
    @objc private func cancelDismiss() {
        number.resignFirstResponder()
        dismiss { (v) in
            guard v else {
                self.delegate?.code(verifier: self, didCancel: false)
                return
            }
            self.delegate?.code(verifier: self, didCancel: true)
        }
    }
    
    public func send() {
        guard let tok = token else {
            return
        }
        guard let t = number.text else {
            return
        }
        var it = String()
        for item in t.characters {
            if item != " "{
                it.append(item)
            }
        }
        
        do {
            let request = try DefaultRequest(url: SpotitPaths.users.cell.confirm, method: .post, authToken: tok, empToken: nil, payload: ["twCode" : it])
            DefaultNetwork.operation.perform(request: request, { (code, message, body, other, arr) in
                guard code == 200 else {
                    if let d = self.delegate {
                        d.code(verifier: self, confirmation: false)
                    }
                    return
                }
                if let d = self.delegate {
                    d.code(verifier: self, confirmation: true)
                }
                self.dismiss({ (val) in
                    guard val else {
                        if let d = self.delegate {
                            d.code(verifier: self, confirmation: false)
                        }
                        return
                    }
                })
            }) { (reason) in
                if let d = self.delegate {
                    d.code(verifier: self, confirmation: false)
                }
            }
        } catch {
            UIView.animate(withDuration: 0.3, animations: {
                self.plusLab.text = "Invalid Code"
                self.plusLab.textColor = UIColor.red
            })
            if let d = self.delegate {
                d.code(verifier: self, confirmation: false)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

