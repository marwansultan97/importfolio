//
//  UserViewModel.swift
//  importfolio
//
//  Created by Marwan Osama on 05/10/2021.
//

import Foundation


class UserViewModel {
    
    private let userRepo: UserRepo
    private var group: DispatchGroup?
    
    init(userRepo: UserRepo) {
        self.userRepo = userRepo
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
    
    var userInfo = PersonalInfosModel(fullname: "", email: "", country: "", gender: "", phone: "", linkedin: "", city: "", day: "", month: "", year: "")
    var educations = [EducationModel]()
    var experiences = [ExperienceModel]()
    var skills = [SkillModel]()
    var projects = [ProjectModel]()
    
    var didReceiveError: (() -> Void)?
    var didReceiveUser: (() -> Void)?
    var didReceiveIsLoading: (() -> Void)?
    
    
    func getUserInfos(email: String) {
        group = DispatchGroup()
        group?.enter()
        isLoading = true
        userRepo.getUserInfos(email: email) { [weak self] info, error in
            if error != nil {
                self?.errorMessage = error?.localizedDescription
            } else {
                guard let info = info else { return }
                self?.userInfo = info
            }
            self?.group?.leave()
        }
        
        group?.notify(queue: .main, execute: { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.user = UserModel(personalInfo: self.userInfo, educations: self.educations, experiences: self.experiences, skills: self.skills, projects: self.projects)
        })
    }
    
    func getUserEducations(email: String) {
        group?.enter()
        userRepo.getUserEducations(email: email) { [weak self] educations in
            self?.educations = educations
            self?.group?.leave()
        }
    }
    
    func getUserExperiences(email: String) {
        group?.enter()
        userRepo.getUserExperiences(email: email) { [weak self] experiences in
            self?.experiences = experiences
            self?.group?.leave()
        }
    }
    
    func getUserSkills(email: String) {
        group?.enter()
        userRepo.getUserSkills(email: email) { [weak self] skills in
            self?.skills = skills
            self?.group?.leave()
        }
    }
    
    func getUserProjects(email: String) {
        group?.enter()
        userRepo.getUserProjects(email: email) { [weak self] projects in
            self?.projects = projects
            self?.group?.leave()
        }
    }
    
}
