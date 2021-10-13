//
//  EducationDetailsViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 21/09/2021.
//

import Foundation

class EducationDetailsViewModel {
    
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

    
    private func validate(educationModel: EducationModel) -> Bool {
        guard !educationModel.university.isEmpty,
              !educationModel.degreeLevel.isEmpty,
              !educationModel.studyField.isEmpty,
              !educationModel.from.isEmpty,
              !educationModel.to.isEmpty else {
            errorMessage = "Please Fill in required Fields"
            return false
        }
        return true
    }

    
    func saveEducationDetails(educationModel: EducationModel) {
        
        guard validate(educationModel: educationModel) else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.updateMyEducation(educationModel: educationModel) { [weak self] error in
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
    
    
    func deleteEducation(educationModel: EducationModel) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.deleteMyEducation(educationModel: educationModel) { [weak self] error in
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
