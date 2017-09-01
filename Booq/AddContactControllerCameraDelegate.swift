//
//  AddContactControllerCameraDelegate.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-07.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import AVFoundation

extension ContactController: CameraCapturePictureViewContentDelegate{
    
    func camera(controller: CameraPictureCaptureView, captured: UIImage?, withInfo: [String : Any]) {
        
    }
    
    func camera(controller: CameraPictureCaptureView, captured: UIImage?, withInfo: [String : Any], toConfirmClose: Any?) -> Bool {
        if let im = captured {
            self.pic.image = im
            self.pic.contentMode = .scaleAspectFit
            addLayersToPic()
            if let d = self.inputDelegate {
                d.contact(controller: self, didEmit: "ne", with: "w", by: .pic)
            }
        }
        picChanged = captured != nil
        return captured != nil
    }
    
    func camera(controller: CameraPictureCaptureView, canceled: Any?) {
        if controller == captureView {
            captureView?.removeFromSuperview()
            captureView?.alpha = 0
            captureView = nil
        }
        picChanged = false
    }
    
    
    func getPicture() {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            present()
            if panBlocker {
                tapDismiss()
            }
            break
        case .notDetermined:
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        DispatchQueue.main.async {
                            self.present()
                            if self.panBlocker {
                                self.tapDismiss()
                            }
                        }
                    } else {
                        // User Rejected
                    }
                })
            }
        case .denied:
            let alertController = UIAlertController (title: "Camera Is Not Allowed", message: "It seems that you denied Booq to use your camera in the past! No worries, if you changed your mind, press Open Settings bellow, then navigate to Privacy > Camera and enable Booq! ", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        case .restricted:
            
            let alertController = UIAlertController (title: "Camera Is Restricted", message: "It looks like there is a restriction on using the camera with Booq. To change this, click Open Settings bellow to open your Settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func present() {
        let initial = CGSize(width: new.frame.width * topPerc * 0.6, height: new.frame.width * topPerc * 0.6)
        captureView = CameraPictureCaptureView(background: pic.backgroundColor, image: nil, origin: CGPoint(x: pic.frame.minX, y: self.new.frame.minY + pic.frame.minY), to: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), relativeTo: initial, corners: pic.layer.cornerRadius)
        view.addSubview(captureView!)
        captureView?.sideCircleView(nil)
        self.captureView?.setUI()
        self.captureView?.delegate = self
        UIView.animate(withDuration: 0.4, animations: {
            self.captureView?.frame.size = CGSize(width: screen.width, height: screen.height)
            self.captureView?.videoPreviewLayer?.cornerRadius = 0
            self.captureView?.center.x = self.view.center.x
            self.captureView?.center.y = self.view.center.y
        }) { (v) in
            self.captureView?.toggles()
        }
    }
    
    private func addLayersToPic() {
        if let height = pic.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: height.constant, height: height.constant), cornerRadius: height.constant / 2).cgPath
            
            pic.layer.shadowPath = path
            pic.layer.shadowRadius = 6.0
            pic.layer.shadowOffset = CGSize(width: 0, height: 7)
            pic.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
            pic.layer.shadowOpacity = 0.5
        }
    }
    
}
