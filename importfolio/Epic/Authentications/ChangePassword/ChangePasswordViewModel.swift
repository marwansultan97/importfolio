//
//  ChangePasswordViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 13/10/2021.
//

import Foundation


class ChangePasswordViewModel {
    
    private let authRepo: AuthenticationRepo
    
    init(authRepo: AuthenticationRepo) {
        self.authRepo = authRepo
    }
    
    
    
    var isLoading: Bool = false {
        didSet {
            didReceiveIsLoading?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            didReceiveError?()
        }
    }
    
    var isPasswordChanged: Bool = false {
        didSet {
            didChangePassword?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    var didChangePassword: (() -> Void)?
    
    func validation(newPassword: String) -> Bool {
        
        guard !newPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        return true
    }
    
    func changePassword(newPassword: String) {
        validation(newPassword: newPassword)
        isLoading = true
        authRepo.changePassword(newPassword: newPassword) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.isPasswordChanged = true
            }
        }
        
    }
    
    
}
