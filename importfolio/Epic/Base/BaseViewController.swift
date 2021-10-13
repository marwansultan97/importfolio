//
//  BaseViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 17/09/2021.
//

import UIKit
import Firebase

class BaseViewController: UIViewController, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkAuth()
    }
    

    private func checkAuth() {
        
        if Auth.auth().currentUser == nil {
            let rootNav = UINavigationController.instantiate(from: .authentication)
            rootNav.modalPresentationStyle = .fullScreen
            present(rootNav, animated: true)
        } else {
            let rootNav = UINavigationController.instantiate(from: .home)
            rootNav.modalPresentationStyle = .fullScreen
            present(rootNav, animated: true)
        }
    }
    
    

}
