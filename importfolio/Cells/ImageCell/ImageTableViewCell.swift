//
//  ImageTableViewCell.swift
//  importfolio
//
//  Created by Marwan Osama on 30/09/2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var projectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(image: String) {
        projectImageView.kf.setImage(with: URL(string: image), options: [])
    }
    
}
