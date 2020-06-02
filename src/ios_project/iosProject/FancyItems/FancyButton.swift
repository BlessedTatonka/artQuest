//
//  FancyButton.swift
//  iosProject
//
//  Created by Patunique on 30.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit

@IBDesignable
class FancyButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var enableSelection: Bool = false
    
    @IBInspectable var selectionColorOn: UIColor = UIColor.black
    @IBInspectable var selectionColorOff: UIColor = UIColor.white
    @IBInspectable var selectionOnTextColor: UIColor = UIColor.black
    @IBInspectable var selectionOffTextColor: UIColor = UIColor.white
    @IBInspectable var disableColor: UIColor = UIColor.black
    
    @IBInspectable var selection: Bool = true
    
    func toggleGroup(group: [FancyButton]) {
            for button in group {
                button.selection = false
                if (button.isEnabled) {
                    button.backgroundColor = selectionColorOff
                } else {
                    //button.backgroundColor = disableColor
                }
            }
            self.selection = true
            self.backgroundColor = selectionColorOn
        }
    
    func toggle() {
        //self.backgroundColor = self.selection ? selectionColorOff : selectionColorOn
        self.selection = !self.selection
    }
    
    var theme: String = ""
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        if (enableSelection) {
            self.backgroundColor = self.selection ? selectionColorOn : selectionColorOff
            
        }
        
        if (!isEnabled) {
            self.backgroundColor = disableColor
        }
        
    }
//    
//    @IBInspectable
//    var borderWidth: CGFloat = 0.0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable
//    var borderColor: UIColor = .black {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
//    
//    @IBInspectable
//    var titleLeftPadding: CGFloat = 0.0 {
//        didSet {
//            titleEdgeInsets.left = titleLeftPadding
//        }
//    }
//
//    @IBInspectable
//    var titleRightPadding: CGFloat = 0.0 {
//        didSet {
//            titleEdgeInsets.right = titleRightPadding
//        }
//    }
//
//    @IBInspectable
//    var titleTopPadding: CGFloat = 0.0 {
//        didSet {
//            titleEdgeInsets.top = titleTopPadding
//        }
//    }
//
//    @IBInspectable
//    var titleBottomPadding: CGFloat = 0.0 {
//        didSet {
//            titleEdgeInsets.bottom = titleBottomPadding
//        }
//    }
//
//    @IBInspectable
//    var imageLeftPadding: CGFloat = 0.0 {
//        didSet {
//            imageEdgeInsets.left = imageLeftPadding
//        }
//    }
//
//    @IBInspectable
//    var imageRightPadding: CGFloat = 0.0 {
//        didSet {
//            imageEdgeInsets.right = imageRightPadding
//        }
//    }
//
//    @IBInspectable
//    var imageTopPadding: CGFloat = 0.0 {
//        didSet {
//            imageEdgeInsets.top = imageTopPadding
//        }
//    }
//
//    @IBInspectable
//    var imageBottomPadding: CGFloat = 0.0 {
//        didSet {
//            imageEdgeInsets.bottom = imageBottomPadding
//        }
//    }
    
//    @IBInspectable var enableImageRightAligned: Bool = false
//    @IBInspectable var enableGradientBackground: Bool = false
//    @IBInspectable var gradientColor1: UIColor = UIColor.black
//    @IBInspectable var gradientColor2: UIColor = UIColor.white
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if enableImageRightAligned,
//            let imageView = imageView {
//                imageEdgeInsets.left = self.bounds.width - imageView.bounds.width - imageRightPadding
//            }
//
//        if enableGradientBackground {
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.frame = self.bounds
//            gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
//            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//            self.layer.insertSublayer(gradientLayer, at: 0)
//        }
//    }
//
}

