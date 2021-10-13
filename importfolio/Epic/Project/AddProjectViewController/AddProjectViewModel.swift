//
//  AddProjectViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 30/09/2021.
//

import Foundation

class AddProjectViewModel {
    
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

    
    
    var didReceiveError: (() -> Void)?
    var didSuccessfullyAdded: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?

    
    private func validate(projectModel: ProjectModel) -> Bool {
        guard !projectModel.name.isEmpty else {
            errorMessage = "Please Fill in Project Name"
            return false
        }
        
        guard !projectModel.category.isEmpty else {
            errorMessage = "Please Choose Project Category"
            return false
        }
        return true
    }

    
    func saveProject(projectModel: ProjectModel) {
        
        guard validate(projectModel: projectModel) else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.meRepo.updateMyProject(projectModel: projectModel) { [weak self] error in
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
    
    
    
    
}
