//
//  ViewController.swift
//  AnimatePopButton
//
//  Created by bob on 9/19/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

extension UIImage{
    func imageWithColor(color: UIColor) -> UIImage?{
        var image = imageWithRenderingMode(.AlwaysTemplate)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

@objc class RoundButton : UIButton{
    var drawColor: UIColor!
    
    dynamic override var state: UIControlState {
        get{
            return super.state
        }
    }
    
    dynamic override var highlighted: Bool{
        set {
            super.highlighted = newValue
        }
        get{
            return super.highlighted
        }
    }
    
    dynamic override var selected: Bool{
        set{
            super.selected = newValue
        }
        get{
            return super.selected
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor .clearColor()
        drawColor = UIColor.orangeColor()
        
        let highlightImg = UIImage(named: "buttonIcon")?.imageWithColor(UIColor.orangeColor())
        let normalImg = UIImage(named: "buttonIcon")?.imageWithColor(UIColor.redColor())
        setImage(highlightImg, forState: .Highlighted)
        //setImage(highlightImg, forState: [.Selected, .Highlighted])
        setImage(highlightImg, forState: .Selected)
        setImage(normalImg, forState: .Normal)
        
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 15
        
        addObserver(self, forKeyPath: "highlighted", options: .New, context: nil)
        addObserver(self, forKeyPath: "selected", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "highlighted" || keyPath == "selected"{
            print("highlighted: \(highlighted)  selected: \(selected)")
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath(ovalInRect: rect)//UIBezierPath(rect: rect)
        drawColor.setFill()
        
        path.fill()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        drawColor = UIColor.whiteColor()
        setNeedsDisplay()
        
        UIView.animateWithDuration(0.15) { 
            self.transform = CGAffineTransformMakeScale(0.9, 0.9)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        self.drawColor = UIColor.orangeColor()
        self.setNeedsDisplay()
        
        transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.AllowUserInteraction], animations: {
            
            self.transform = CGAffineTransformIdentity
            
            }) { (finished) in
                
        }
    }
}

class ViewController: UIViewController {
    
    var button: RoundButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.layer.speed = 0.05
        
        button = RoundButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 80, height: 80)))
        view.addSubview(button)
        
        button.center = view.center
    }
}

