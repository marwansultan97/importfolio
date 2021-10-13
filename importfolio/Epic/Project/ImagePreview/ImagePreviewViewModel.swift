//
//  ImagePreviewViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 02/10/2021.
//

import Foundation

class ImagePreviewViewModel {
    
    private let projectsRepo: ProjectsRepo
    
    
    init(projectsRepo: ProjectsRepo) {
        self.projectsRepo = projectsRepo
    }
    
    var errorMessage: String? {
        didSet {
            didReceiveError?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            didReceiveLoading?()
        }
    }
    
    var isDeleted: Bool = false {
        didSet {
            didSuccessfullyDeleted?()
        }
    }
    
    var didReceiveError: (() -> Void)?
    var didSuccessfullyDeleted: (() -> Void)?
    var didReceiveLoading: (() -> Void)?
    
    func deleteImage(projectModel: ProjectModel, imageModel: ImageModel) {
        isLoading = true
        projectsRepo.deleteImage(project: projectModel, imageModel: imageModel) { [weak self] error in
            self?.isLoading = false
            if error != nil {
                self?.errorMessage = error?.localizedDescription
            } else {
                self?.isDeleted = true
            }
        }
    }
    
}
