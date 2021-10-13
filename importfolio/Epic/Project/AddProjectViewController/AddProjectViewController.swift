//
//  AddProjectViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 30/09/2021.
//

import UIKit
import SwiftyMenu

protocol AddProjectViewControllerDelegate {
    func didAddSuccessfully()
}

class AddProjectViewController: UIViewController, Storyboarded {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var projectNameTF: UITextField!
    @IBOutlet weak var projectLinkTF: UITextField!
    @IBOutlet weak var projectCategoryDD: SwiftyMenu!
    @IBOutlet weak var projectDescTV: UITextView!
    @IBOutlet weak var techTF: UITextField!
    
    private let viewModel = AddProjectViewModel(meRepo: MeRepoImpl())
    var delegate: AddProjectViewControllerDelegate?
    var projectModel: ProjectModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        viewModelBinding()
        
    }
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
        
        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }
        
        viewModel.didSuccessfullyAdded = { [weak self] in
            guard let self = self else { return }
            self.showDone(animationType: .done) {
                self.delegate?.didAddSuccessfully()
                self.dismiss(animated: true)
            }
        }
        
        
    }
    
    private func setupViews() {
        containerView.layer.cornerRadius = 15
        contentView.layer.cornerRadius = 15
        containerView.makeBorders(borderWidth: 0.5, borderColor: .white.withAlphaComponent(0.8))
        
        
        techTF.makeShadowsAndCorners(cornerRadius: 5)
        techTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        techTF.setTextHorizontalPadding(10)
        
        projectNameTF.makeShadowsAndCorners(cornerRadius: 5)
        projectNameTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        projectNameTF.setTextHorizontalPadding(10)
        
        projectLinkTF.makeShadowsAndCorners(cornerRadius: 5)
        projectLinkTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        projectLinkTF.setTextHorizontalPadding(10)
        
        projectDescTV.makeShadowsAndCorners(cornerRadius: 5)
        projectDescTV.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        var att = SwiftyMenuAttributes().attributes
        att.placeHolderStyle = .value(text: "Select...", textColor: .white.withAlphaComponent(0.7))
        
        projectCategoryDD.configure(with: att)
        projectCategoryDD.items = APP_CATEGORY_LIST
        projectCategoryDD.didCollapse = {
            self.projectCategoryDD.heightConstraint.constant = 40
        }
        projectCategoryDD.didSelectItem = { menu, item, index in
            self.projectCategoryDD.toggle()
        }
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        guard var project = projectModel else { return }
        project.name = projectNameTF.text ?? ""
        project.github = projectLinkTF.text ?? ""
        project.category = projectCategoryDD.selectedIndex == nil ? "" : APP_CATEGORY_LIST[projectCategoryDD.selectedIndex!]
        project.description = projectDescTV.text ?? ""
        project.technologies = techTF.text ?? ""
        viewModel.saveProject(projectModel: project)
        
    }
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
