//
//  EducationViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 19/09/2021.
//

import Foundation


class EducationViewModel {
    
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
    
    var educations: [EducationModel] = [] {
        didSet {
            didReceiveEducations?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveEducations: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?

    
    func getUserEducations() {
        isLoading = true
        meRepo.getMyEducations { [weak self] educations in
            guard let self = self else { return }
            self.isLoading = false
            self.educations = educations
                
            
        }
    }

}
