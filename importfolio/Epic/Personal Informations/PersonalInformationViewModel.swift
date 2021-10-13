//
//  PersonalInformationViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import Foundation
import UIKit

class PersonalInformationViewModel {
    
    private let meRepo: MeRepo
    
    init(meRepo: MeRepo) {
        self.meRepo = meRepo
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
    
    var profile: PersonalInfosModel? {
        didSet {
            didReceiveProfile?()
        }
    }
    
    var isUpdated: Bool = false {
        didSet {
            didUpdateInfos?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveProfile: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    var didUpdateInfos: (() -> Void)?

    
    func getUserInfo() {
        isLoading = true
        meRepo.getMyInfos { [weak self] info, error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.profile = info
            }
        }
    }
    
    func updateInfo(personalInfo: PersonalInfosModel) {
        isLoading = true
        meRepo.updateMyInfos(personalModel: personalInfo) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.getUserInfo()
            }
        }
    }
    
    
    
    func updateUserImage(image: UIImage) {
        isLoading = true
        meRepo.updateMyImage(image: image) { [weak self] error in
            guard let self = self else { return }
            if error != nil { self.errorMessage = error?.localizedDescription ; self.isLoading = false }
            else {
                self.getUserInfo()
            }
        }
    }
    
    
}
