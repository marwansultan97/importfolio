//
//  SkillTableViewCell.swift
//  importfolio
//
//  Created by Marwan Osama on 10/09/2021.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var skillLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
