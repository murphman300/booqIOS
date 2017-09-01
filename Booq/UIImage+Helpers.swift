//
//  UIImage+Helpers.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-14.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import SCKBase

extension UIImage {
    
    func sFuncImageFixOrientation() -> UIImage? {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi * 2))
        }
        
        if self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi * 2));
        }
        
        if self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent,bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        if self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored {
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.height,height:self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        }
        
        guard let cgimg:CGImage = ctx.makeImage() else {
            return nil
        }
        return UIImage(cgImage: cgimg)
    }
    
    func cropTo(_ rect: CGRect) -> UIImage? {
        let new = CGRect(x: rect.origin.y, y: rect.origin.x, width: rect.height, height: rect.width)
        guard let cgImage : CGImage = self.cgImage else { return nil }
        guard let croppedCGImage: CGImage = cgImage.cropping(to: new) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: .right)
    }
    
    func cropToRelativeToScreen(_ rect: CGRect) -> UIImage? {
        guard let cgImage : CGImage = self.cgImage else { return nil }
        
        
        let width = (rect.width/screen.width) * self.size.width
        let height = (rect.height/screen.height) * self.size.height
        
        let x = (self.size.width - width) / 2
        let y = (self.size.height - height) / 2
        
        let rectangle = CGRect(x: x, y: y, width: width, height: width)
        guard let croppedCGImage: CGImage = cgImage.cropping(to: rectangle) else { return nil }
        let img =  UIImage(cgImage: croppedCGImage)
        switch img.imageOrientation {
        case .up:
            print("image is up")
        default:
            print("oriented \(img.imageOrientation)")
        }
        return img
    }
    
}
