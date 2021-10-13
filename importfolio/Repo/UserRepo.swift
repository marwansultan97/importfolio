//
//  UserRepo.swift
//  importfolio
//
//  Created by Marwan Osama on 05/10/2021.
//

import Foundation
import UIKit
import Firebase


protocol UserRepo {
    func getUserInfos(email: String, completion: @escaping(PersonalInfosModel?, Error?) -> Void)
    func getUserEducations(email: String, completion: @escaping([EducationModel]) -> Void)
    func getUserExperiences(email: String, completion: @escaping([ExperienceModel]) -> Void)
    func getUserSkills(email: String, completion: @escaping([SkillModel]) -> Void)
    func getUserProjects(email: String, completion: @escaping([ProjectModel]) -> Void)
}

class UserRepoImpl: UserRepo {
    
    func getUserInfos(email: String, completion: @escaping (PersonalInfosModel?, Error?) -> Void) {
        FirebaseService.shared.read(uid: email, object: PersonalInfosModel.self, child: FirebaseCollections.personal.rawValue) { error, personalInfos in
            if error != nil {
                completion(nil,error)
            } else {
                completion(personalInfos,nil)
            }
        }
    }
    
    func getUserEducations(email: String, completion: @escaping ([EducationModel]) -> Void) {
        FirebaseService.shared.readList(uid: email, object: EducationModel.self, child: "\(FirebaseCollections.educations.rawValue)") { list in
            completion(list)
        }
    }
    
    func getUserExperiences(email: String, completion: @escaping ([ExperienceModel]) -> Void) {
        FirebaseService.shared.readList(uid: email, object: ExperienceModel.self, child: "\(FirebaseCollections.experiences.rawValue)") { list in
            completion(list)
        }
    }
    
    func getUserSkills(email: String, completion: @escaping ([SkillModel]) -> Void) {
        FirebaseService.shared.readList(uid: email, object: SkillModel.self, child: "\(FirebaseCollections.skills.rawValue)") { list in
            completion(list)
        }
    }
    
    func getUserProjects(email: String, completion: @escaping ([ProjectModel]) -> Void) {
        FirebaseService.shared.readList(uid: email, object: ProjectModel.self, child: FirebaseCollections.projects.rawValue) { projects in
            completion(projects)
        }
        
        
    }
    
}
