//
//  EducationModel.swift
//  importfolio
//
//  Created by Marwan Osama on 10/09/2021.
//

import Foundation


struct EducationModel: Codable {
    var id: String
    var university: String
    var degreeLevel: String
    var studyField: String
    var from: String
    var to: String
    var grade: String?
}

extension EducationModel {
    static let mock = EducationModel(id: "", university: "Ain Shams University", degreeLevel: "BACHELOR'S DEGREE, Mechanical Engineering", studyField: "", from: "2015", to: "2020", grade: nil)
    
    static let mock2 = EducationModel(id: "", university: "Ain Shams University", degreeLevel: "BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical EngineeringBACHELOR'S DEGREE, Mechanical Engineering", studyField: "", from: "2015", to: "2020", grade: nil)
    
    static let mock3 = EducationModel(id: "", university: "Ain Shams University", degreeLevel: "BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical Engineering,BACHELOR'S DEGREE, Mechanical EngineeringBACHELOR'S DEGREE, Mechanical EngineeringLOR'S DEGREE, Mechanical EngineeringLOR'S DEGREE, Mechanical EngineeringLOR'S DEGREE, Mechanical Engineering", studyField: "", from: "2015", to: "2020", grade: nil)
}
