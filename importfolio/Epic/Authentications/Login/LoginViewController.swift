//
//  LoginViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 03/09/2021.
//

import UIKit

class LoginViewController: UIViewController, Storyboarded {

    @IBOutlet weak var loginLogoImage: UIImageView!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailSeparator: UIView!
    
    @IBOutlet weak var passwordSeparator: UIView!
    @IBOutlet weak var eyeButton: UIButton!
    
    
    private let viewModel = LoginViewModel(authRepo: AuthenticationRepoImpl())
    private var isPasswordHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupViews()
        viewModelBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
        
        viewModel.didReceiveLoggingResponse = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }
        
        viewModel.didResetPassword = { [weak self] in
            guard let self = self else { return }
            self.showAlert(message: "Please Check Your Email", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
    }
    
    
    private func setupViews() {
        
        loginLogoImage.makeShadowsAndCorners(shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 4, shadowColor: .white)
        passwordTF.delegate = self
        emailTF.delegate = self
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    func showForgotPasswordAlert() {
        let alert = UIAlertController(title: "importfolio", message: "Please write your email to reset your password", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Enter your email..."
            tf.font = UIFont.systemFont(ofSize: 13)
            tf.autocorrectionType = .no
            tf.borderStyle = .roundedRect
            tf.autocapitalizationType = .none
            tf.keyboardType = .emailAddress
            tf.keyboardAppearance = .default
            tf.backgroundColor = .clear
            tf.borderStyle = .none
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { _ in
            guard let email = alert.textFields?.first?.text, email.isValid(.email) else {
                self.showAlert(message: "Enter a valid email", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
                return }
            self.viewModel.resetPassword(email: email)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func eyeTapped(_ sender: UIButton) {
        isPasswordHidden.toggle()
        passwordTF.isSecureTextEntry = isPasswordHidden
        eyeButton.setImage(isPasswordHidden ? UIImage(named: "eye") : UIImage(named: "eyeslash"), for: .normal)
        
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        showForgotPasswordAlert()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        viewModel.signin(email: email, password: password)
    }
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
        let registerVC = RegisterViewController.instantiate(from: .authentication)
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            if textField == self.emailTF { self.emailSeparator.alpha = 1 }
            else { self.passwordSeparator.alpha = 1 }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            if textField == self.emailTF { self.emailSeparator.alpha = 0.5 }
            else { self.passwordSeparator.alpha = 0.5 }
        }
    }
}
