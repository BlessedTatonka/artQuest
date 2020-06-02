//
//  FancyTextField.swift
//  iosProject
//
//  Created by Patunique on 08.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit

@IBDesignable
class FancyTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 34, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
}
