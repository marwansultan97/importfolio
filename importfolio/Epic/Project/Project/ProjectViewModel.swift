//
//  ProjectViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 29/09/2021.
//

import Foundation


class ProjectViewModel {
    
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
    
    var projects: [ProjectModel] = [] {
        didSet {
            didReceiveProjects?()
        }
    }
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveProjects: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    
    func getUserProjects() {
        isLoading = true
        meRepo.getMyProjects { [weak self] projects in
            guard let self = self else { return }
            self.isLoading = false
            self.projects = projects
        }
    }
    
    
}
