//
//  ExperienceModel.swift
//  importfolio
//
//  Created by Marwan Osama on 10/09/2021.
//

import Foundation


struct ExperienceModel: Codable {
    var id: String
    var title: String
    var company: String
    var description: String
    var fromMonth: String
    var fromYear: String
    var toMonth: String
    var toYear: String
    var isCurrentlyWorking: Bool
}

extension ExperienceModel {
    static let mock = ExperienceModel(id: "", title: "iOS Developer", company: "Al Tahaluf Group", description: "· Followed Apple's Human Interface guidelines to create products aligned with iOS UI norms.\n·Integrated existing third-party APIs to shorten development times.\n· Applied Apple's Swift development language to code native apps for iOS platform.\n· Designed user experience frameworks applicable to multiple screen sizes, including both iPad and iPhone.\n· Researched and selected APIs for integration into development projects.", fromMonth: "", fromYear: "Feb 2021", toMonth: "Present", toYear: "", isCurrentlyWorking: false)
    static let mock2 = ExperienceModel(id: "", title: "iOS Developer", company: "Al Tahaluf Group", description: "· Followed Apple's Human Interface guidelines to create products aligned with iOS UI norms.\n·Integrated existing third-party APIs to shorten development times.\n· Applied Apple's Swift development language to code native apps for iOS platform.\n· Designed user experience frameworks applicable to multiple screen sizes, including both iPad and iPhone.\n· Researched and selected APIs for integration into development projects.", fromMonth: "", fromYear: "Feb 2021", toMonth: "", toYear: "", isCurrentlyWorking: false)
    static let mock3 = ExperienceModel(id: "", title: "iOS Developer", company: "Al Tahaluf Group", description: "· Followed Apple's Human Interface guidelines to create products aligned with iOS UI norms.\n·Integrated existing third-party APIs to shorten development times.\n· Applied Apple's Swift development language to code native apps for iOS platform.\n· Designed user experience frameworks applicable to multiple screen sizes, including both iPad and iPhone.\n· Researched and selected APIs for integration into development projects.", fromMonth: "", fromYear: "Feb 2021", toMonth: "Present", toYear: "", isCurrentlyWorking: true)
}
