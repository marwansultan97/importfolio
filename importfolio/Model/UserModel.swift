//
//  User.swift
//  importfolio
//
//  Created by Marwan Osama on 26/09/2021.
//

import Foundation

struct UserModel: Codable {
    
    var personalInfo: PersonalInfosModel
    var educations: [EducationModel]
    var experiences: [ExperienceModel]
    var skills: [SkillModel]
    var projects: [ProjectModel]
}
