//
//  String+Ex.swift
//  importfolio
//
//  Created by Marwan Osama on 04/09/2021.
//

import UIKit
import SwiftyMenu


extension String: SwiftyMenuDisplayable {
    
    public var displayableValue: String {
        return self
    }
    
    public var retrievableValue: Any {
        return self
    }
    
    
    
    enum ValidationType {
        case alphabet
        case alphabetWithSpace
        case alphabetNum
        case alphabetNumWithSpace
        case userName
        case name
        case email
        case number
        case password
        case mobileNumber
        case postalCode
        case zipcode
        case currency
        case amount
        
        var regex: String {
            switch self {
            case .alphabet:
                return "[A-Za-z]+"
            case .alphabetWithSpace:
                return "[A-Za-z ]*"
            case .alphabetNum:
                return "[A-Za-z-0-9]*"
            case .alphabetNumWithSpace:
                return "[A-Za-z0-9 ]*"
            case .userName:
                return "[A-Za-z0-9_]*"
            case .name:
                return "^[A-Z a-z]*$"
            case .email:
                return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            case .number:
                return "[0-9]+"
            case .password:
                return "^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$"
            case .mobileNumber:
                return "^[0-9]{8,11}$"
            case .postalCode:
                return "^[A-Za-z0-9- ]{1,10}$"
            case .zipcode:
                return "^[A-Za-z0-9]{4,}$"
            case .currency:
                return "^([0-9]+)(\\.([0-9]{0,2})?)?$"
            case .amount:
                return "^\\s*(?=.*[1-9])\\d*(?:\\.\\d{1,2})?\\s*$"
            }
        }
    }
    
    func isValid(_ type: ValidationType) -> Bool {
        guard !isEmpty else { return false }
        let regTest = NSPredicate(format: "SELF MATCHES %@", type.regex)
        return regTest.evaluate(with: self)
    }
    
    
    func replaceDotWithComma() -> String {
        let newString = self.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
        return newString
    }
    
    
}
