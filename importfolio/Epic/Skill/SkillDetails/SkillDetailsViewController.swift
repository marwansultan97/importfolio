//
//  SkillDetailsViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 14/09/2021.
//

import UIKit

protocol SkillDetailsDelegate {
    func didSaveSuccessfully()
}

class SkillDetailsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var skillTF: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let viewModel = SkillDetailsViewModel(meRepo: MeRepoImpl())
    
    var skillModel: SkillModel?
    var delegate: SkillDetailsDelegate?
    
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
                self.delegate?.didSaveSuccessfully()
                self.dismiss(animated: true)
            }
        }
        
        viewModel.didSuccessfullydeleted = { [weak self] in
            guard let self = self else { return }
            self.showDone(animationType: .deleted) {
                self.delegate?.didSaveSuccessfully()
                self.dismiss(animated: true)
            }
        }
        
    }

    private func setupViews() {
        containerView.layer.cornerRadius = 15
        containerView.makeBorders(borderWidth: 0.5, borderColor: .white.withAlphaComponent(0.8))
        skillTF.makeShadowsAndCorners(cornerRadius: 5)
        skillTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        skillTF.setTextHorizontalPadding(10)
        skillTF.text = skillModel?.skill
        deleteButton.alpha = skillModel?.skill == "" ? 0 : 1
        deleteButton.uniqueCorners(topLeft: 0, topRight: 15, bottomLeft: 40, bottomRight: 0)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard var skillModel = skillModel else { return }
        skillModel.skill = skillTF.text ?? ""
        viewModel.saveSkill(skillModel: skillModel)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        showAlert(message: "Are you sure you want to delete this skill?",
                  actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        guard let skillModel = self.skillModel else { return }
                        self.viewModel.deleteSkill(skillModel: skillModel)
                    }),
                    UIAlertAction(title: "No", style: .default, handler: nil)])
    }
    
    
}
