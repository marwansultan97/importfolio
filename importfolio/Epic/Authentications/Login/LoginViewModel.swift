//
//  LoginViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import Foundation

class LoginViewModel {
    
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
    
    var isLoggedIn: Bool? {
        didSet {
            didReceiveLoggingResponse?()
        }
    }
    
    var isPasswordReset: Bool = false {
        didSet {
            didResetPassword?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveLoggingResponse: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    var didResetPassword: ( ()-> Void)?
    
    
    func validation(email: String, password: String) -> Bool {
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }

        
        guard email.isValid(.email) else {
            errorMessage = "Please enter a valid email format"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
    
    func signin(email: String, password: String) {
        guard validation(email: email, password: password) else { return }
        isLoading = true
        authRepo.signin(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.isLoggedIn = true
            }
        }
    }
    
    func resetPassword(email: String) {
        isLoading = true
        authRepo.resetPassword(email: email) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.isPasswordReset = true
            }
        }
    }
    
}
