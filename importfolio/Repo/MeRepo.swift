//
//  UserRepo.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import Foundation
import UIKit
import Firebase


protocol MeRepo {
    
    func getMyInfos(completion: @escaping(PersonalInfosModel?, Error?) -> Void)
    func updateMyInfos(personalModel: PersonalInfosModel, completion: @escaping(Error?) -> Void)
    func updateMyImage(image: UIImage, completion: @escaping(Error?) -> Void)
    
    func getMyEducations(completion: @escaping([EducationModel]) -> Void)
    func updateMyEducation(educationModel: EducationModel, completion: @escaping(Error?) -> Void)
    func deleteMyEducation(educationModel: EducationModel, completion: @escaping(Error?) -> Void)
    
    func getMyExperiences(completion: @escaping([ExperienceModel]) -> Void)
    func updateMyExperience(experienceModel: ExperienceModel, completion: @escaping(Error?) -> Void)
    func deleteMyExperience(experienceModel: ExperienceModel, completion: @escaping(Error?) -> Void)
    
    
    func getMySkills(completion: @escaping([SkillModel]) -> Void)
    func updateMySkill(skillModel: SkillModel, completion: @escaping(Error?) -> Void)
    func deleteMySkill(skillModel: SkillModel, completion: @escaping(Error?) -> Void)
    
    func getMyProjects(completion: @escaping([ProjectModel]) -> Void)
    func updateMyProject(projectModel: ProjectModel, completion: @escaping(Error?) -> Void)
    func deleteMyProject(projectModel: ProjectModel, completion: @escaping(Error?) -> Void)

    
}


class MeRepoImpl: MeRepo {
    
    func getMyProjects(completion: @escaping ([ProjectModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.readList(uid: uid, object: ProjectModel.self, child: FirebaseCollections.projects.rawValue) { projects in
            completion(projects)
        }
    }
    
    func updateMyProject(projectModel: ProjectModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.write(uid: uid, object: projectModel, child: "\(FirebaseCollections.projects.rawValue)/\(projectModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteMyProject(projectModel: ProjectModel, completion: @escaping (Error?) -> Void) {
        FirebaseService.shared.delete(child: "\(FirebaseCollections.projects.rawValue)/\(projectModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func getMySkills(completion: @escaping ([SkillModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.readList(uid: uid, object: SkillModel.self, child: "\(FirebaseCollections.skills.rawValue)") { list in
            completion(list)
        }
    }
    
    func updateMySkill(skillModel: SkillModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.write(uid: uid, object: skillModel, child: "\(FirebaseCollections.skills.rawValue)/\(skillModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteMySkill(skillModel: SkillModel, completion: @escaping (Error?) -> Void) {
        FirebaseService.shared.delete(child: "\(FirebaseCollections.skills.rawValue)/\(skillModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func getMyExperiences(completion: @escaping ([ExperienceModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.readList(uid: uid, object: ExperienceModel.self, child: "\(FirebaseCollections.experiences.rawValue)") { list in
            completion(list)
        }
    }
    
    func updateMyExperience(experienceModel: ExperienceModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.write(uid: uid, object: experienceModel, child: "\(FirebaseCollections.experiences.rawValue)/\(experienceModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteMyExperience(experienceModel: ExperienceModel, completion: @escaping(Error?) -> Void) {
        FirebaseService.shared.delete(child: "\(FirebaseCollections.experiences.rawValue)/\(experienceModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func getMyEducations(completion: @escaping ([EducationModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.readList(uid: uid, object: EducationModel.self, child: "\(FirebaseCollections.educations.rawValue)") { list in
            completion(list)
        }
    }
    
    func updateMyEducation(educationModel: EducationModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.write(uid: uid, object: educationModel, child: "\(FirebaseCollections.educations.rawValue)/\(educationModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteMyEducation(educationModel: EducationModel, completion: @escaping(Error?) -> Void) {
        FirebaseService.shared.delete(child: "\(FirebaseCollections.educations.rawValue)/\(educationModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    
    
    func getMyInfos(completion: @escaping (PersonalInfosModel?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.read(uid: uid, object: PersonalInfosModel.self, child: FirebaseCollections.personal.rawValue) { error, personalInfos in
            if error != nil {
                completion(nil,error)
            } else {
                completion(personalInfos,nil)
            }
        }
    }
    
    func updateMyInfos(personalModel: PersonalInfosModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.write(uid: uid, object: personalModel, child: FirebaseCollections.personal.rawValue) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateMyImage(image: UIImage, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        StorageService.shared.uploadImage(uiimage: image, child: FirebaseCollections.personal.rawValue) { url, error in
            if error != nil {
                completion(error)
            } else {
                guard let url = url else { return }
                FirebaseService.shared.writeValue(uid: uid, values: ["image" : url], child: "\(FirebaseCollections.personal.rawValue)") { error in
                    if error != nil { completion(error) }
                    else { completion(nil) }
                }
            }
        } completionS: { _ in}

    }
    
    
}
