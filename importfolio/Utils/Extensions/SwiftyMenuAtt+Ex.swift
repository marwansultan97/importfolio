//
//  SwiftyMenuAtt+Ex.swift
//  importfolio
//
//  Created by Marwan Osama on 13/09/2021.
//

import SwiftyMenu

extension SwiftyMenuAttributes {
    
    var attributes: SwiftyMenuAttributes {
        var attributes = SwiftyMenuAttributes()
        attributes.textStyle = .value(color: UIColor.white, separator: " & ", font: .systemFont(ofSize: 12, weight: .semibold))
        attributes.expandingAnimation = .spring(level: .low)
        attributes.expandingTiming = .value(duration: 0.3, delay: 0)
        attributes.collapsingTiming = .value(duration: 0.3, delay: 0)
        attributes.collapsingAnimation = .spring(level: .low)
        attributes.rowStyle = .value(height: 40, backgroundColor: .thirdBlack, selectedColor: .darkGray)
        attributes.separatorStyle = .value(color: .black, isBlured: false, style: .none)
        attributes.accessory = .disabled
        attributes.arrowStyle = .default
        attributes.multiSelect = .disabled
        attributes.roundCorners = .all(radius: 5)
        attributes.height = .value(height: 200)
        attributes.headerStyle = .value(backgroundColor: .thirdBlack, height: 40)
        attributes.border = .value(color: .white.withAlphaComponent(0.8), width: 0.8)
        attributes.hideOptionsWhenSelect = .disabled
        return attributes
    }
}
