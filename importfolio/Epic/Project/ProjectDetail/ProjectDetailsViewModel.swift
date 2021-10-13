//
//  ProjectDetailsViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 30/09/2021.
//

import Foundation
import UIKit

class ProjectDetailsViewModel {
    
    private let meRepo: MeRepo
    private let projectsRepo: ProjectsRepo
    
    init(meRepo: MeRepo, projectsRepo: ProjectsRepo) {
        self.meRepo = meRepo
        self.projectsRepo = projectsRepo
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
    
    var isSaved: Bool = false {
        didSet {
            didSuccessfullySaved?()
        }
    }
    
    var projectModel: ProjectModel? {
        didSet {
            didSuccessfullyRefreshed?()
        }
    }
    
    var images = [ImageModel]() {
        didSet {
            didReceiveImages?()
        }
    }
    
    var isDeleted: Bool = false {
        didSet {
            didSuccessfullyDeleted?()
        }
    }
    
    

    
    
    var didReceiveError: (() -> Void)?
    var didSuccessfullySaved: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    var didSuccessfullyRefreshed: (() -> Void)?
    var didReceiveImages: (() -> Void)?
    var didSuccessfullyDeleted: (()-> Void)?
    
    
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
                    self.isSaved = true
                }
            }
        }
    }
    
    func getProjectImages(email: String, project: ProjectModel) {
        
        self.projectsRepo.getProjectImages(uid: email, project: project) { [weak self] images in
            self?.images = images
        }
    }
    
    func refreshProjectData(email: String, project: ProjectModel) {
        isLoading = true
        self.projectsRepo.getProject(uid: email, id: project.id) { [weak self] projectModel, error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.projectModel = projectModel
                self.getProjectImages(email: email, project: project)
            }
        }
    }
    
    func changeAppImage(image: UIImage, project: ProjectModel) {
        isLoading = true
        projectsRepo.changeAppImage(project: project, image: image) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.isSaved = true
            }
        }
    }
    
    func addImage(image: UIImage, projectModel: ProjectModel, id: String) {
        isLoading = true
        projectsRepo.addImage(project: projectModel, id: id, image: image) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                self.isSaved = true
            }
        }
    }
    
    func deleteProject(projectModel: ProjectModel) {
        isLoading = true
        meRepo.deleteMyProject(projectModel: projectModel) { [weak self] error in
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
