//
//  ChangePasswordViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 13/10/2021.
//

import UIKit

class ChangePasswordViewController: UIViewController, Storyboarded {

    @IBOutlet weak var newPasswordTF: UITextField!
    
    private let viewModel = ChangePasswordViewModel(authRepo: AuthenticationRepoImpl())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBinding()
    }
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
        
        viewModel.didChangePassword = { [weak self] in
            guard let self = self else { return }
            self.showAlert(message: "Password Changed Successfully", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
        
        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }
    }
    

    @IBAction func changeTapped(_ sender: UIButton) {
        guard let newPassword = newPasswordTF.text else { return }
        viewModel.changePassword(newPassword: newPassword)
    }
    

}
