//
//  ExperienceDetailsViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 21/09/2021.
//

import Foundation

class ExperienceDetailsViewModel {
    
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
    
    var isAdded: Bool = false {
        didSet {
            didSuccessfullyAdded?()
        }
    }
    
    var isDeleted: Bool = false {
        didSet {
            didSuccessfullydeleted?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didSuccessfullyAdded: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    var didSuccessfullydeleted: (() -> Void)?
    
    
    func validate(experienceModel: ExperienceModel) -> Bool {
        guard !experienceModel.company.isEmpty,
              !experienceModel.title.isEmpty,
              !experienceModel.fromMonth.isEmpty,
              !experienceModel.fromYear.isEmpty else {
            errorMessage = "Please Fill in required Fields"
            return false
        }
        
        if !experienceModel.isCurrentlyWorking {
            guard !experienceModel.toYear.isEmpty,
                  !experienceModel.toMonth.isEmpty else {
                errorMessage = "Please Fill in Ending year and month"
                return false
            }
        }
        
        return true
    }
    
    
    func saveExperienceDetails(experienceModel: ExperienceModel) {
        guard validate(experienceModel: experienceModel) else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.updateMyExperience(experienceModel: experienceModel) { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                if error != nil {
                    self.errorMessage = error?.localizedDescription
                } else {
                    self.isAdded = true
                }
            }
        }
    }
    
    func deleteExperience(experienceModel: ExperienceModel) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.deleteMyExperience(experienceModel: experienceModel) { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                if error != nil {
                    self.errorMessage = error?.localizedDescription
                } else {
                    self.isDeleted = true
                }
            }
        }
    }
    
}
