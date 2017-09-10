//
//  APMosaicView.swift
//  Capture
//
//  Created by ShawnDu on 15/12/8.
//  Copyright © 2015年 ShawnDu. All rights reserved.
//

import UIKit

class APMosaicView: UIView {

    var previousTouchLocation: CGPoint = CGPoint.zero
    var currentTouchLocation:  CGPoint = CGPoint.zero
    var hideImage:    CGImage?
    var scratchImage: CGImage?
    var contextMask:  CGContext?
    
    var sizeBrush: CGFloat = 60.0 {
        
        didSet{
            contextMask?.setLineWidth(sizeBrush)
        }
        
    }
    var hideView:  UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    //MARK: CoreGraphics methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard self.scratchImage != nil else { return }
        let imageToDraw = UIImage.init(cgImage: self.scratchImage!)
        imageToDraw.draw(in: self.bounds)
    }
    
    func setBrushSize(_ size: CGFloat){
        contextMask?.setLineWidth(size)
    }
    
    func getEndImg(_ image: UIImage) ->UIImage{
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func setHiddenView(_ hideView: UIView){
        
        let colorspace = CGColorSpaceCreateDeviceGray()
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(hideView.bounds.size, false, 0)
        hideView.layer.render(in: UIGraphicsGetCurrentContext()!)
        hideView.layer.contentsScale = scale
        hideImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        guard hideImage != nil else { return }
        
        let imageWidth = (hideImage?.width)!
        let imageHeight = (hideImage?.height)!
        
        let pixels = CFDataCreateMutable(nil, imageWidth * imageHeight);
        contextMask = CGContext(data: CFDataGetMutableBytePtr(pixels), width: imageWidth, height: imageHeight , bitsPerComponent: 8, bytesPerRow: imageWidth, space: colorspace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        let dataProvider = CGDataProvider(data: pixels!)
        
        contextMask?.setFillColor(UIColor.black.cgColor)
        contextMask?.fill(self.frame)
        
        contextMask?.setStrokeColor(UIColor.white.cgColor)
        contextMask?.setLineWidth(2000)
        
        contextMask?.setLineCap(CGLineCap.round)
        
        let mask = CGImage(maskWidth: imageWidth, height: imageHeight, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: imageWidth, provider: dataProvider!, decode: nil, shouldInterpolate: false);
        scratchImage = hideImage?.masking(mask!)
        
        self.hideImageView()
        
    }
    
    func setPathColor(_ fillColor: UIColor, strokeColor: UIColor){
        contextMask?.setLineWidth(self.sizeBrush)
        
        contextMask?.setFillColor(fillColor.cgColor)
        
        contextMask?.setStrokeColor(strokeColor.cgColor)
    }
    
    func hideImageView(){
        
        contextMask?.move(to: CGPoint(x: 0, y: 0))
        contextMask?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        contextMask?.strokePath();
        self.setNeedsDisplay()
        
    }
    
    func scratchTheViewFrom(_ startPoint: CGPoint, endPoint: CGPoint){
        
        let scale = UIScreen.main.scale;
        
        contextMask?.move(to: CGPoint(x: startPoint.x * scale, y: (self.frame.size.height - startPoint.y) * scale))
        contextMask?.addLine(to: CGPoint(x: endPoint.x * scale, y: (self.frame.size.height - endPoint.y) * scale))
        contextMask?.strokePath();
        self.setNeedsDisplay()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch : UITouch =  (event?.touches(for: self)?.first)!
        self.currentTouchLocation = touch.location(in: self)
        print("\(self.currentTouchLocation)")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = event!.touches(for: self)?.first
        if (!previousTouchLocation.equalTo(CGPoint.zero))
        {
            currentTouchLocation = touch!.location(in: self)
        }
        
        previousTouchLocation = touch!.previousLocation(in: self)
        self.scratchTheViewFrom(previousTouchLocation, endPoint: currentTouchLocation)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = event!.touches(for: self)?.first
        
        if (!previousTouchLocation.equalTo(CGPoint.zero))
        {
            previousTouchLocation = touch!.previousLocation(in: self)
            self.scratchTheViewFrom(previousTouchLocation, endPoint: currentTouchLocation)
            
        }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
}
