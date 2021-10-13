//
//  SkillDetailsViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 23/09/2021.
//

import Foundation


class SkillDetailsViewModel {
    
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

    
    private func validate(skillModel: SkillModel) -> Bool {
        guard skillModel.skill.count >= 2 else {
            errorMessage = "Skill must be at least 2 characters"
            return false
        }
        return true
    }

    
    func saveSkill(skillModel: SkillModel) {
        
        guard validate(skillModel: skillModel) else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.updateMySkill(skillModel: skillModel) { [weak self] error in
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
    
    
    func deleteSkill(skillModel: SkillModel) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.deleteMySkill(skillModel: skillModel) { [weak self] error in
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
