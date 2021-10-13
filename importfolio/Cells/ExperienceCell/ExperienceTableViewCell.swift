//
//  ExperienceTableViewCell.swift
//  importfolio
//
//  Created by Marwan Osama on 10/09/2021.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(experienceModel: ExperienceModel) {
        jobTitleLabel.text = experienceModel.title
        companyNameLabel.text = experienceModel.company
        descriptionLabel.text = experienceModel.description
        fromLabel.text = experienceModel.fromMonth + " " + experienceModel.fromYear
        toLabel.text = experienceModel.isCurrentlyWorking ? "Present" : "\(experienceModel.toMonth)  \(experienceModel.toYear)"
    }
    
}
