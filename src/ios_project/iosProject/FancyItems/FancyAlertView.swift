//
//  FancyAlert.swift
//  iosProject
//
//  Created by Patunique on 21.05.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import Foundation
import UIKit

class FancyAlertView : UIView {
    static let instance = FancyAlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    private var question: QuestionProtocol!
    
    @IBAction func yes(_ sender: Any) {
        question.help()
        parentView.removeFromSuperview()
    }
    
    @IBAction func no(_ sender: Any) {
        parentView.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("FancyAlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    private func commonInit() {
        
    }
    
    func showAlert(question: QuestionProtocol) {
        self.question = question
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
}
