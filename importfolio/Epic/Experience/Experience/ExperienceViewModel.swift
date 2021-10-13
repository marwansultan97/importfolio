//
//  ExperienceViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 21/09/2021.
//

import Foundation

class ExperienceViewModel {
    
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
    
    var experiences: [ExperienceModel] = [] {
        didSet {
            didReceiveExperiences?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveExperiences: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    
    func getUserExperiences() {
        isLoading = true
        meRepo.getMyExperiences { [weak self] experiences in
            guard let self = self else { return }
            self.isLoading = false
            self.experiences = experiences
        }
    }
    
    
}
