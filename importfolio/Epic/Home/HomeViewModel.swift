//
//  HomeViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 26/09/2021.
//

import Foundation

class HomeViewModel {
    
    private let meRepo: MeRepo
    private var group: DispatchGroup?
    
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
    
    var user: UserModel? {
        didSet {
            didReceiveUser?()
        }
    }
    
    var personalInfo = PersonalInfosModel(fullname: "", email: "", country: "", gender: "", phone: "", linkedin: "", city: "", day: "", month: "", year: "")
    var educations = [EducationModel]()
    var experiences = [ExperienceModel]()
    var skills = [SkillModel]()
    var projects = [ProjectModel]()
    
    
    var didReceiveError: (() -> Void)?
    var didReceiveUser: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?

    func getUserInfo() {
        group = DispatchGroup()
        group?.enter()
        
        isLoading = true
        meRepo.getMyInfos { [weak self] info, error in
            guard let self = self else { return }
            if error != nil {
                self.errorMessage = error?.localizedDescription
            } else {
                if let info = info {
                    self.personalInfo = info
                }
            }
            self.group?.leave()
        }
        
        
        group?.notify(queue: .main, execute: { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.user = UserModel(personalInfo: self.personalInfo, educations: self.educations, experiences: self.experiences, skills: self.skills, projects: self.projects)
        })
    }
    
    func getUserEducations() {
        group?.enter()
        meRepo.getMyEducations { [weak self] educations in
            guard let self = self else { return }
            self.educations = educations
            self.group?.leave()
        }
    }
    
    func getUserExperiences() {
        group?.enter()
        meRepo.getMyExperiences { [weak self] experiences in
            guard let self = self else { return }
            self.experiences = experiences
            self.group?.leave()
        }
    }
    
    func getUserSkills() {
        group?.enter()
        meRepo.getMySkills { [weak self] skills in
            guard let self = self else { return }
            self.skills = skills
            self.group?.leave()
        }
    }
    
    func getUserProject() {
        group?.enter()
        meRepo.getMyProjects { [weak self] projects in
            guard let self = self else { return }
            self.projects = projects
            self.group?.leave()
        }
    }
    
    
}
