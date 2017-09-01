//
//  CameraCaptureController.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-07.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase
import AVFoundation

protocol CameraCaptureControllerContentDelegate {
    func camera(controller: CameraCaptureController, captured: Any?, withInfo: [String:Any])
}

class CameraCaptureController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    var exit = UIButton()
    var messageLabel = UILabel()
    var topBar = UIView()
    
    
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var delegate: CameraCaptureControllerContentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            session?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            switch UIDevice.current.orientation{
            case .landscapeLeft:
                videoPreviewLayer?.connection.videoOrientation = .landscapeRight
            case .landscapeRight:
                videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
            default:
                videoPreviewLayer?.connection.videoOrientation = .portrait
            }
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topBar)
            session?.startRunning()
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
        exit.addTarget(self, action: #selector(dismissSelf), for: UIControlEvents.touchUpInside)
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if let d = self.delegate {
                messageLabel.text = "Success"
                self.dismiss(animated: true, completion: {
                    d.camera(controller: self, captured: nil, withInfo: [:])
                    self.delegate = nil
                })
            }
        }
    }
    
    func capture() {
        
    }
    
    func dismissSelf(){
        self.dismiss(animated: true) {
            self.delegate = nil
        }
    }
}




