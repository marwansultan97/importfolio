//
//  Alert+Extension.swift
//  HealthCareSystem
//
//  Created by Marwan Osama on 10/06/2021.
//  Copyright © 2021 ALATRAF. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func alert(title: String = "Health Care", message: String, actions: [(String, UIAlertAction.Style, ((UIAlertAction) -> Void)? )]) {
        
        let alerting = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alerting.addAction(UIAlertAction(title: action.0, style: action.1, handler: action.2))
        }
        self.present(alerting, animated: true, completion: nil)
    }
    
    func settingsAlertController(message: String) {
        let alertController = UIAlertController(title: "Alatraf", message: message, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (UIAlertAction) in
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
      }

      alertController.addAction(cancelAction)
      alertController.addAction(settingsAction)
      self.present(alertController, animated: true, completion: nil)

   }
    
}
