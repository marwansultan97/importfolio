//
//  UIColor+Ex.swift
//  importfolio
//
//  Created by Marwan Osama on 03/09/2021.
//

import UIKit

extension UIColor {
    
    class var thirdAppColor: UIColor {
        return UIColor(named: "thirdAppColor")!
    }
    
    class var appColor: UIColor {
        return UIColor(named: "appColor")!
    }
    
    class var thirdBlack: UIColor {
        return UIColor(named: "thirdBlack")!
    }
    
    class var secondaryBlack: UIColor {
        return UIColor(named: "secondaryBlack")!
    }
    
    class var backgroundModified: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }
    
    class var labelModified: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return .black
        }
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF),
            green: CGFloat((rgb >> 8) & 0xFF),
            blue: CGFloat(rgb & 0xFF),
            alpha: alpha
        )
    }

    
    
}
