//
//  EducationTableViewCell.swift
//  importfolio
//
//  Created by Marwan Osama on 10/09/2021.
//

import UIKit

class EducationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var degreeFieldLabel: UILabel!
    @IBOutlet weak var yearFromLabel: UILabel!
    @IBOutlet weak var yearToLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(educationModel: EducationModel) {
        universityLabel.text = educationModel.university
        degreeFieldLabel.text = educationModel.degreeLevel
        yearFromLabel.text = educationModel.from
        yearToLabel.text = educationModel.to
    }
    
}
