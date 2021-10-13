//
//  NSObject+Extension.swift
//  HealthCareSystem
//
//  Created by Marwan Osama on 10/06/2021.
//  Copyright © 2021 ALATRAF. All rights reserved.
//

import UIKit

protocol HasApply { }

extension HasApply {
    func apply(closure: (Self)->()) {
        closure(self)
    }
}

extension NSObject: HasApply { }
