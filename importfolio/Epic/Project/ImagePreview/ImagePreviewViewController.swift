//
//  ImagePreviewViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 30/09/2021.
//

import UIKit
import Kingfisher
import Firebase

protocol ImagePreviewDelegate {
    func didDeleteImage()
}

class ImagePreviewViewController: UIViewController, Storyboarded {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let viewModel = ImagePreviewViewModel(projectsRepo: ProjectsRepoImpl())
    
    var imageModel: ImageModel?
    var projectModel: ProjectModel?
    var delegate: ImagePreviewDelegate?
    var email: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModelBinding()
        setupImage()
        
    }
    
    func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let errorMessage = self.viewModel.errorMessage else { return }
            self.showAlert(message: errorMessage, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
        
        viewModel.didReceiveLoading = { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }
        
        viewModel.didSuccessfullyDeleted = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didDeleteImage()
            self.dismiss(animated: true)
        }
    }
    
    func setupImage() {
        guard let image = imageModel?.imageURL else { return }
        selectedImageView.kf.setImage(with: URL(string: image))
        
        if email != Auth.auth().currentUser?.email?.replaceDotWithComma() {
            deleteButton.alpha = 0
        }
    }
    

    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard let projecModel = projectModel, let imageModel = imageModel else { return }
        viewModel.deleteImage(projectModel: projecModel, imageModel: imageModel)
    }
    
}
