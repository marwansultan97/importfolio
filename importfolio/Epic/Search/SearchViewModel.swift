//
//  SearchViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 05/10/2021.
//

import Foundation

class SearchViewModel {
    
    private let userRepo: UserRepo
    
    init(userRepo: UserRepo) {
        self.userRepo = userRepo
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
    
    var searchedInfo: PersonalInfosModel? {
        didSet {
            didReceiveInfo?()
        }
    }
    
    var isEmptyInfo: Bool = false {
        didSet {
            didReceiveEmptyInfo?()
        }
    }
    
    var didReceiveInfo: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    var didReceiveError: (() -> Void)?
    var didReceiveEmptyInfo: (() -> Void)?

    
    func searchUser(email: String) {
        isLoading = true
        userRepo.getUserInfos(email: email) { [weak self] info, error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                if info == nil { self.isEmptyInfo = true }
                else { self.searchedInfo = info }
            }
        }
    }
    
}
