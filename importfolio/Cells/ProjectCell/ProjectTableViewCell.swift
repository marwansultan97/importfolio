//
//  ProjectTableViewCell.swift
//  importfolio
//
//  Created by Marwan Osama on 28/09/2021.
//

import UIKit
import Kingfisher

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectCategoryLabel: UILabel!
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var descTF: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        projectImageView.layer.cornerRadius = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureCell(project: ProjectModel) {
        projectImageView.kf.setImage(with: URL(string: project.appImage))
        projectNameLabel.text = project.name
        projectCategoryLabel.text = project.category
        descTF.text = project.description
    }
    
}
