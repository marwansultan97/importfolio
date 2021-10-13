//
//  UITextField+Ex.swift
//  importfolio
//
//  Created by Marwan Osama on 17/09/2021.
//

import UIKit

extension UITextField {
    
    func setTextHorizontalPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
}
