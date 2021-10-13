//
//  RegisterViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 04/09/2021.
//

import UIKit
import SwiftyMenu

class RegisterViewController: UIViewController, Storyboarded {

    
    @IBOutlet weak var registerLogoImage: UIImageView!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var fullnameSeparator: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailSeparator: UIView!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordSeparator: UIView!
    
    @IBOutlet weak var phonenumberTF: UITextField!
    
    @IBOutlet weak var phonenumberSeparator: UIView!
    @IBOutlet weak var countyDropDown: SwiftyMenu!
    @IBOutlet weak var eyeButton: UIButton!
    
    
    private let viewModel = RegisterViewModel(authRepo: AuthenticationRepoImpl())
    private var isPasswordHidden = true
    var country = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupViews() {
        registerLogoImage.makeShadowsAndCorners(shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 4, shadowColor: .white)
        passwordTF.delegate = self
        emailTF.delegate = self
        fullnameTF.delegate = self
        phonenumberTF.delegate = self
        
        
        let countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
        var attributes = SwiftyMenuAttributes()
        attributes.textStyle = .value(color: UIColor.white, separator: " & ", font: .systemFont(ofSize: 12, weight: .semibold))
        attributes.placeHolderStyle = .value(text: "Choose your country", textColor: .white.withAlphaComponent(0.7))
        attributes.expandingAnimation = .spring(level: .low)
        attributes.expandingTiming = .value(duration: 0.3, delay: 0)
        attributes.collapsingTiming = .value(duration: 0.3, delay: 0)
        attributes.collapsingAnimation = .spring(level: .low)
        attributes.rowStyle = .value(height: 30, backgroundColor: .appColor, selectedColor: .darkGray)
        attributes.separatorStyle = .value(color: .black, isBlured: false, style: .none)
        attributes.accessory = .disabled
        attributes.arrowStyle = .default
        attributes.multiSelect = .disabled
        attributes.height = .value(height: Int(SCREEN_HEIGHT*0.2))
        attributes.headerStyle = .value(backgroundColor: .appColor, height: 30)
        attributes.hideOptionsWhenSelect = .disabled
        countyDropDown.configure(with: attributes)
        countyDropDown.items = countryList
        
        countyDropDown.didCollapse = {
            self.countyDropDown.heightConstraint.constant = 30
        }
        countyDropDown.didSelectItem = { menu, item, index in
            self.country = item.displayableValue
            self.countyDropDown.toggle()
        }
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
    }
    
    
    @IBAction func eyeTapped(_ sender: UIButton) {
        isPasswordHidden.toggle()
        passwordTF.isSecureTextEntry = isPasswordHidden
        eyeButton.setImage(isPasswordHidden ? UIImage(named: "eye") : UIImage(named: "eyeslash"), for: .normal)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        let phone = phonenumberTF.text ?? ""
        let fullname = fullnameTF.text ?? ""
        let country = country
        viewModel.signup(email: email, password: password, fullname: fullname, phone: phone, country: country)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            if textField == self.fullnameTF { self.fullnameSeparator.alpha = 1 }
            else if textField == self.emailTF { self.emailSeparator.alpha = 1 }
            else if textField == self.passwordTF { self.passwordSeparator.alpha = 1 }
            else { self.phonenumberSeparator.alpha = 1 }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            if textField == self.fullnameTF { self.fullnameSeparator.alpha = 0.5 }
            else if textField == self.emailTF { self.emailSeparator.alpha = 0.5 }
            else if textField == self.passwordTF { self.passwordSeparator.alpha = 0.5 }
            else { self.phonenumberSeparator.alpha = 0.5 }
        }
    }
    
}

