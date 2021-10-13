//
//  RegisterViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 17/09/2021.
//

import Foundation

class RegisterViewModel {
    
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
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveLoggingResponse: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    
    func validation(email: String, password: String, fullname: String, phone: String, country: String) -> Bool {
        
        guard !email.isEmpty, !password.isEmpty, !fullname.isEmpty, !phone.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard !country.isEmpty else {
            errorMessage = "Please select your country"
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
        
        guard phone.isValid(.mobileNumber) else {
            errorMessage = "Please enter a valid Phone Number"
            return false
        }
        
        return true
    }
    
    func signup(email: String, password: String, fullname: String, phone: String, country: String) {
        
        guard validation(email: email, password: password, fullname: fullname, phone: phone, country: country) else {
            return
        }
        
        let personalModel = PersonalInfosModel(fullname: fullname, email: email, country: country, gender: nil, phone: phone, linkedin: nil, city: nil, day: nil, month: nil, year: nil)
        
        isLoading = true
        
        authRepo.signup(personalModel: personalModel, password: password) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.isLoggedIn = true
            }
        }
    }
    
}
