//
//  UIViewController+Ex.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import UIKit
import MBProgressHUD
import Lottie

enum Animations: String {
    case done
    case deleted
}


extension UIViewController {

    func showAlert(title: String = "importfolio", message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    func showIndicator(withTitle title: String = "", and description: String = "") {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.backgroundView.backgroundColor = .black.withAlphaComponent(0.5)
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
    
    func showSuccess(completionHandler: (()-> Void)? = nil) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.customView = UIImageView(image: UIImage(named: "checkmark"))
        indicator.label.text = "Done"
        indicator.mode = .customView
        indicator.show(animated: true)
        indicator.hide(animated: true, afterDelay: 1)
        indicator.completionBlock = completionHandler
    }
    
    func showErrorWithDelay(errorMessage: String, delay: TimeInterval = 2.5, completionHandler: (()-> Void)? = nil) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        label.text = errorMessage
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        indicator.customView = label
        indicator.mode = .customView
        indicator.show(animated: true)
        indicator.hide(animated: true, afterDelay: delay)
        indicator.completionBlock = completionHandler
    }
    
    
    func showLoading(_ show: Bool) {
        if let lastView = view.subviews.last, lastView is AnimationView {
            for view in self.view.subviews {
                if view.backgroundColor == .black.withAlphaComponent(0.5) { view.removeFromSuperview() }
                if let animationView = view as? AnimationView, animationView.animationSpeed == 2 {  view.removeFromSuperview() }
            }
        }
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backgroundView.backgroundColor = .black.withAlphaComponent(0.5)
        if show {
            view.addSubview(backgroundView)
            let animation = Animation.named("loading2", bundle: Bundle.main)
            let animationView = AnimationView(animation: animation)
            animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            view.addSubview(animationView)
            animationView.center = self.view.center
            animationView.animationSpeed = 2
            animationView.loopMode = .loop
            animationView.play()
        } else {
            for view in self.view.subviews {
                if view.backgroundColor == .black.withAlphaComponent(0.5) { view.removeFromSuperview() }
                if let animationView = view as? AnimationView, animationView.animationSpeed == 2 {  view.removeFromSuperview() }
            }
        }
    }
    
    func showLoadingWithoutOverlay(_ show: Bool) {
        if show {
            let animation = Animation.named("loading", bundle: Bundle.main)
            let animationView = AnimationView(animation: animation)
            animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            view.addSubview(animationView)
            animationView.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT/2) - 50)
            animationView.animationSpeed = 2
            animationView.loopMode = .loop
            animationView.play()
        } else {
            for view in self.view.subviews {
                if view.backgroundColor == .black.withAlphaComponent(0.5) { view.removeFromSuperview() }
                if let animationView = view as? AnimationView, animationView.animationSpeed == 2 {  view.removeFromSuperview() }
            }
        }
    }
    
    func showDone(animationType: Animations, completion: (() -> Void)? = nil) {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backgroundView.backgroundColor = .black.withAlphaComponent(0.4)
        let animation = Animation.named(animationType.rawValue, bundle: Bundle.main)
        let animationView = AnimationView(animation: animation)
        animationView.animationSpeed = animationType == .done ? 1.5 : 1
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.addSubview(backgroundView)
        view.addSubview(animationView)
        animationView.center = self.view.center
        animationView.play { _ in
            backgroundView.removeFromSuperview()
            animationView.removeFromSuperview()
            completion?()
        }

    }
    
    
    

    
}
