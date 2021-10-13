//
//  Date+Extension.swift
//  HealthCareSystem
//
//  Created by Marwan Osama on 10/06/2021.
//  Copyright © 2021 ALATRAF. All rights reserved.
//

import Foundation

extension Date {
    
    func getStringFromDate(dateFormat: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let dateString = dateformatter.string(from: self)
        return dateString
    }
    
    
}
