//
//  PersonalInfosModel.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import Foundation

struct PersonalInfosModel: Codable {
    var fullname: String
    var email: String
    var country: String
    var image: String?
    var jobTitle: String?
    var summary: String?
    var gender: String?
    var phone: String
    var linkedin: String?
    var city: String?
    var day: String?
    var month: String?
    var year: String?
}
