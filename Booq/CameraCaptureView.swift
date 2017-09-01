//
//  CameraCaptureView.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-14.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//


import SCKBase
import AVFoundation


protocol CameraCapturePictureViewContentDelegate {
    
    func camera(controller: CameraPictureCaptureView, captured: UIImage?, withInfo: [String:Any])
    
    func camera(controller: CameraPictureCaptureView, captured: UIImage?, withInfo: [String:Any], toConfirmClose: Any?) -> Bool
    
    func camera(controller: CameraPictureCaptureView, canceled: Any?)
    
}

class CameraPictureCaptureView: UIView, AVCaptureMetadataOutputObjectsDelegate, ProfileHeaderActionButtonDelegate, AVCapturePhotoCaptureDelegate {
    
    var exit = UIButton()
    var messageLabel = UILabel()
    var topBar = UIView()
    
    var overLayImage : ImageView = {
        var v = ImageView(secondaries: true, cornerRadius: 0.0)
        v.alpha = 0
        return v
    }()
    
    var take : ImagedActionButton = {
        var v = ImagedActionButton(layouts: CGSize(width: 0.6, height: 0.6))
        v.alpha = 0
        v.untouchedColor = colors.loginTfBack
        v.touchedColor = colors.loginContainer
        v.actionType = .null
        v.imageColor = colors.lineColor.withAlphaComponent(0.5)
        return v
    }()
    
    var flip : ImagedActionButton = {
        var v = ImagedActionButton(layouts: CGSize(width: 0.8, height: 0.8))
        v.alpha = 0
        v.imageColor = colors.loginTfBack
        v.untouchedColor = UIColor.clear
        v.touchedColor = UIColor.clear
        v.actionType = .null
        v.imageShouldHaveUnderLyingShadow = true
        return v
    }()
    
    var back : ActionButton = {
        var v = ActionButton(secondaries: true)
        v.alpha = 0
        v.untouchedColor = UIColor.clear//colors.loginTfBack
        v.touchedColor = UIColor.clear//colors.loginContainer
        v.setTitleColor(colors.loginTfBack.withAlphaComponent(0.9), for: .normal)
        v.actionType = .null
        v.setTitle("Back", for: .normal)
        return v
    }()
    
    var session: AVCaptureSession?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var stillImageOutput : AVCapturePhotoOutput?
    
    var delegate: CameraCapturePictureViewContentDelegate?
    
    var origin = CGPoint()
    
    var point = CGPoint()
    
    var relative = CGSize()
    
    private var type = CameraType()
    
    private var interBlock : ConstraintBlock?
    
    private var focusContainer : FocusView = {
        var v = FocusView(within: FocusLayerLayout(size: CGSize(width: screen.width * 0.9, height: screen.width * 0.9)).border(BorderItem(corner: 10, color: nil)))
        v.alpha = 0
        return v
    }()
    
    private var focus : UIImageView = {
        var v = UIImageView()
        v.alpha = 0
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(background: UIColor?, image: UIImage?, origin: CGPoint, to: CGPoint, relativeTo: CGSize, corners: CGFloat? = 0) {
        self.init(frame: CGRect(origin: origin, size: relativeTo))
        self.relative = relativeTo
        self.point = to
        self.origin = origin
        backgroundColor = (background != nil ? background! : UIColor.clear).withAlphaComponent(1.0)
        add()
        viewDidLoad {
            self.layer.addSublayer(self.videoPreviewLayer!)
            self.videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        }
        type = .front
    }
    
    func setAs(background: UIColor?, image: UIImage?, origin: CGPoint, to: CGPoint, relativeTo: CGSize, corners: CGFloat? = 0) -> CameraPictureCaptureView {
        return self
    }
    
    func applyFocusView() {
        
        addSubview(focusContainer)
        focusContainer.backgroundColor = UIColor.clear
        focusContainer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        focusContainer.applyLayout()
        
        addSubview(focus)
        
        print(focusContainer.resultingFocusFrame)
        
        focus.frame = focusContainer.resultingFocusFrame
        focus.layer.cornerRadius = focusContainer.layout!.bordered!.corner
        focus.layer.masksToBounds = true
        focus.backgroundColor = UIColor.clear
        
    }
    
    func animateUp() {
    }
    
    func setUI(){
        self.session?.startRunning()
        addLayersToButtons()
    }
    
    func toggles() {
        DispatchQueue.main.async {
            self.take.block.toggle()
            self.back.block.toggle()
            self.applyFocusView()
            self.bringSubview(toFront: self.focusContainer)
            self.bringSubview(toFront: self.take)
            self.bringSubview(toFront: self.topBar)
            self.bringSubview(toFront: self.back)
            UIView.animate(withDuration: 0.35, animations: {
                self.take.alpha = 1
                self.back.alpha = 1
                self.topBar.center.y = self.topBar.frame.height / 2
                self.flip.alpha = 1
                self.layoutIfNeeded()
            }) { (v) in
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.layer.cornerRadius = 0
                self.layer.masksToBounds = true
                self.focusContainer.alpha = 1
            })
        }
    }
    
    func replace() {
        
    }
    
    func add() {
        addSubview(take)
        addSubview(topBar)
        addSubview(back)
        topBar.addSubview(flip)
        
        topBar.frame = CGRect(x: 0, y: -100, width: screen.width, height: 100)
        topBar.contrastBackGround(.top, UIColor.black.withAlphaComponent(0.4), UIColor.black.withAlphaComponent(0.0), [0.0, 0.98])
        
        flip.delegate = self
        
        flip.image = #imageLiteral(resourceName: "flipCam")
        
        flip.width(self, .width, ConstraintVariables(.width, topBar.frame.height - 20).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .width, variables: ConstraintVariables(.width, buttonSizes.mainheight * 2.5).fixConstant())
        }
        
        flip.height(self, .height, ConstraintVariables(.height, topBar.frame.height - 20).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        
        flip.bottom(topBar, .bottom, ConstraintVariables(.bottom, 0).fixConstant(), nil)
        
        flip.right(topBar, .right, ConstraintVariables(.right, 0).fixConstant(), nil)
        
        
        take.delegate = self
        take.image = #imageLiteral(resourceName: "aperture_frame")
        take.width(self, .width, ConstraintVariables(.width, buttonSizes.mainheight * 2).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .width, variables: ConstraintVariables(.width, buttonSizes.mainheight * 2.5).fixConstant())
        }
        take.height(self, .height, ConstraintVariables(.height, buttonSizes.mainheight * 2).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        take.bottom(self, .bottom, ConstraintVariables(.bottom, -16).makeSecondary(), nil)
        take.top(self, .bottom, ConstraintVariables(.top, 16).fixConstant(), nil)
        take.horizontal(self, .horizontal, ConstraintVariables(.horizontal, 0), nil)
        take.apply({
            self.take.block.switchStates(.top, .bottom)
        }) {
            self.take.block.switchStates(.width, .width)
            self.take.block.switchStates(.height, .height)
            self.take.setTitle("Save", for: .normal)
        }
        take.cornerRadius = buttonSizes.mainheight
        
        back.delegate = self
        back.width(self, .width, ConstraintVariables(.width, buttonSizes.mainheight * 2).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .width, variables: ConstraintVariables(.width, buttonSizes.mainheight * 2.5).fixConstant())
        }
        back.height(self, .height, ConstraintVariables(.height, buttonSizes.mainheight * 1.2).fixConstant()) { () -> SecondaryContraintParameters in
            return SecondaryContraintParameters(element: .height, variables: ConstraintVariables(.height, buttonSizes.mainheight).fixConstant())
        }
        back.vertical(take, .vertical, ConstraintVariables(.vertical, 0).fixConstant(), nil)
        back.left(self, .left, ConstraintVariables(.left, 16).fixConstant(), nil)
        back.apply({
        }) {
            self.back.block.switchStates(.width, .width)
            self.back.block.switchStates(.height, .height)
            self.back.setTitle("Cancel", for: .normal)
        }
        back.cornerRadius = 5
        
        take.activateConstraints()
        flip.activateConstraints()
        back.activateConstraints()
        
    }
    
    func viewDidLoad(_ applyCaptureFrame: (()->())?) {
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.addInput(input)
            captureMetadataOutput = AVCaptureMetadataOutput()
            stillImageOutput = AVCapturePhotoOutput.init()
            stillImageOutput?.photoSettingsForSceneMonitoring = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            captureMetadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session?.addOutput(stillImageOutput!)
            session?.addOutput(captureMetadataOutput!)
            captureMetadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
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
            applyCaptureFrame?()
        } catch {
            print(error)
            return
        }
    }
    
    func reloadCam() {
        type = type.toggle
        session?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()
        session = nil
        videoPreviewLayer = nil
        stillImageOutput = nil
        loadCam()
        self.session?.startRunning()
        self.bringSubview(toFront: focusContainer)
        self.bringSubview(toFront: topBar)
        self.bringSubview(toFront: take)
        self.bringSubview(toFront: back)
    }
    
    
    var captureMetadataOutput : AVCaptureMetadataOutput?
    
    func loadCam() {
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: type.camera)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.addInput(input)
            captureMetadataOutput = AVCaptureMetadataOutput()
            stillImageOutput = AVCapturePhotoOutput.init()
            stillImageOutput?.photoSettingsForSceneMonitoring = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            captureMetadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session?.addOutput(stillImageOutput!)
            session?.addOutput(captureMetadataOutput!)
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
            self.layer.addSublayer(self.videoPreviewLayer!)
            self.videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        } catch {
            print(error)
            return
        }
    }
    
    var error: NSError?
    
    func header(button: ActionButton, wasPressed info: Any?) {
        if button == take {
            print("take")
            guard !blocked else { return }
            blocked = true
            if captureState {
                print("save and dismiss")//resumeCamera()
                dismissSelfOnSavePictureToContact()
            } else {
                takePicture()
            }
        }
        if button == flip {
            reloadCam()
        }
        if button == back {
            if captureState {
                resumeCamera()
            } else {
                print("dismiss")//takePicture()
                dismissSelfOnBack()
            }
        }
    }
    
    var captureState : Bool = false
    
    var blocked: Bool = false
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didCapturePhotoForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("captured")
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            let dataProvider = CGDataProvider(data: imageData as CFData)
            let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: .right)
            
            let size = self.focusContainer.resultingFocusFrame
            let newSize = size.toRectSizeFromRatio(image.size)
            if let cropped = image.cropTo(newSize) {
                DispatchQueue.main.async {
                    self.captureState = true
                    self.focus.image = cropped
                    self.pauseCameraFromCapture()
                }
            } else {
                self.resumeCamera()
            }
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhotoSampleBuffer rawSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        pauseCamera()
    }
    
    private func takePicture() {
        let settings = AVCapturePhotoSettings()
        guard let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first else {
            return
        }
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,  kCVPixelBufferWidthKey as String: screen.width,  kCVPixelBufferHeightKey as String : screen.height] as [String : Any]
        settings.previewPhotoFormat = previewFormat
        if let output = self.stillImageOutput {
            output.capturePhoto(with: settings, delegate: self)
        }
    }
    
    private func pauseCamera() {
        session?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()
        session = nil
        videoPreviewLayer = nil
        stillImageOutput = nil
    }
    
    private func pauseCameraFromCapture() {
        self.back.setTitle("Cancel", for: .normal)
        self.focus.contentMode = .scaleAspectFit
        self.blocked = false
        self.bringSubview(toFront: self.focus)
        self.focus.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.topBar.center.y = -self.topBar.frame.height / 2
            self.focusContainer.focusLayer.fillColor = UIColor.black.cgColor
            self.take.imageV.alpha = 0
            self.take.setTitle("Save", for: .normal)
            self.take.setTitleColor(colors.lineColor.withAlphaComponent(0.5), for: .normal)
            self.topBar.alpha = 0
            self.pauseCamera()
        })
    }
    
    func resumeCamera() {
        loadCam()
        self.bringSubview(toFront: focusContainer)
        self.bringSubview(toFront: topBar)
        self.bringSubview(toFront: take)
        self.bringSubview(toFront: back)
        self.focus.image = nil
        self.session?.startRunning()
        self.blocked = false
        self.captureState = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.topBar.center.y = self.topBar.frame.height / 2
                self.back.setTitle("Back", for: .normal)
                self.take.setTitleColor(UIColor.clear, for: .normal)
                self.take.imageV.alpha = 1
                self.focusContainer.focusLayer.fillColor = UIColor.black.withAlphaComponent(0.3).cgColor
                self.focus.alpha = 0
                self.topBar.alpha = 1
            })
        }
    }
    
    
    private func addLayersToButtons() {
        if let height = take.block.heightConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: height.constant, height: height.constant), cornerRadius: buttonSizes.mainheight).cgPath
            take.layer.shadowPath = path
            take.layer.shadowRadius = 6.0
            take.layer.shadowOffset = CGSize(width: 0, height: 7)
            take.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            take.layer.shadowOpacity = 0.5
            take.layer.cornerRadius = buttonSizes.mainheight
        }
        if let height = back.block.heightConstraint, let width = back.block.widthConstraint {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width.constant, height: height.constant), cornerRadius: back.layer.cornerRadius).cgPath
            back.layer.shadowPath = path
            back.layer.shadowRadius = 10.0
            back.layer.shadowOffset = CGSize(width: 0, height: 7)
            back.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
            back.layer.shadowOpacity = 0.5
            back.layer.cornerRadius = back.layer.cornerRadius
        }
    }
    
    func dismissSelfOnBack(){
        self.take.block.performMain()
        print(self.origin)
        UIView.animate(withDuration: 0.35, animations: {
            self.layer.cornerRadius = self.relative.height / 2
            self.frame.size = self.relative
            self.center.x = self.origin.x + (self.relative.width / 2)
            self.center.y = self.origin.y + (self.relative.width / 2)
            self.topBar.center.y = -self.topBar.frame.height / 2
            self.topBar.alpha = 0
            self.layoutIfNeeded()
            self.alpha = 1
        }) { (v) in
            self.pauseCamera()
            if let d = self.delegate {
                d.camera(controller: self, canceled: nil)
            }
        }
    }
    
    func dismissSelfOnSavePictureToContact(){
        self.take.block.performMain()
        self.bringSubview(toFront: self.focus)
        UIView.animate(withDuration: 0.35, animations: {
            self.videoPreviewLayer?.removeFromSuperlayer()
            self.backgroundColor = UIColor.clear
            self.focus.layer.cornerRadius = self.relative.height / 2
            self.focus.frame.size = self.relative
            self.focus.center.x = self.origin.x + (self.relative.width / 2)
            self.focus.center.y = self.origin.y + (self.relative.width / 2)
            self.topBar.center.y = -self.topBar.frame.height / 2
            self.topBar.alpha = 0
            self.focusContainer.alpha = 0
            self.layoutIfNeeded()
        }) { (v) in
            self.pauseCamera()
            if let d = self.delegate {
                if d.camera(controller: self, captured: self.focus.image, withInfo: [:], toConfirmClose: nil) {
                    d.camera(controller: self, canceled: nil)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
    }
}

extension CGRect {
    
    func toRectSizeFromRatio(_ other: CGSize) -> CGRect {
        
        if other.width > self.width {
            let ratioW = self.width / screen.width
            let ratioH = self.height / screen.height
            let x = self.origin.x / self.width
            let y = self.origin.y / self.height
            if self.height == self.width {
                let w = other.width * ratioW
                let h = w
                let tx = (other.width - w) / 2
                let ty = (other.height - h) / 2
                let t = CGRect(x: tx, y: ty, width: w, height: h)
                return t
            } else {
                return CGRect(x: x * ratioW, y: y * ratioH, width: self.width * ratioW, height: self.height * ratioH)
            }
        } else {
            return .zero
        }
        
    }
    
    
}
