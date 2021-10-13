//
//  Storyboarded.swift
//  importfolio
//
//  Created by Marwan Osama on 04/09/2021.
//

import UIKit

protocol Storyboarded {
    static func instantiate(from storyboard: Storyboard) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(from storyboard: Storyboard) -> Self {
        let identifier = String(describing: self)
        let vc = UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return vc as! Self
    }
}

extension UINavigationController: Storyboarded { }
extension UITabBarController: Storyboarded { }
