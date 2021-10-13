//
//  UIImage+Extension.swift
//  HealthCareSystem
//
//  Created by Marwan Osama on 10/06/2021.
//  Copyright © 2021 ALATRAF. All rights reserved.
//

import UIKit

extension UIImage {
    func convertImageToBase64EncodedString() -> String {
        let imageData: NSData = self.jpegData(compressionQuality: 0.3)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return  "data:image/jpeg;base64,\(imageStr)"
    }
}
