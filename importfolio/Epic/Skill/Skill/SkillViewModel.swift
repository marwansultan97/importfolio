//
//  SkillViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 23/09/2021.
//

import Foundation


class SkillViewModel {
    
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
    
    var skills: [SkillModel] = [] {
        didSet {
            didReceiveSkills?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveSkills: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    
    func getUserSkills() {
        isLoading = true
        meRepo.getMySkills { [weak self] skills in
            guard let self = self else { return }
            self.isLoading = false
            self.skills = skills
        }
    }
    
    
    
    
}
