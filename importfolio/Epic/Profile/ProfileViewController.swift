//
//  ProfileViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 11/09/2021.
//

import UIKit
import Firebase
import Kingfisher
import JJFloatingActionButton

class ProfileViewController: UIViewController, Storyboarded {
    
    var userModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func personalInfoTapped(_ sender: UIButton) {
        let personalVC = PersonalInforamtionsViewController.instantiate(from: .personalInfo)
        navigationController?.pushViewController(personalVC, animated: true)
    }
    
    @IBAction func educationTapped(_ sender: UIButton) {
        let educationVC = EducationViewController.instantiate(from: .education)
        navigationController?.pushViewController(educationVC, animated: true)
    }
    
    @IBAction func experienceTapped(_ sender: UIButton) {
        let experienceVC = ExperienceViewController.instantiate(from: .experience)
        navigationController?.pushViewController(experienceVC, animated: true)
    }
    
    @IBAction func skillsTapped(_ sender: UIButton) {
        let skillVC = SkillViewController.instantiate(from: .skill)
        navigationController?.pushViewController(skillVC, animated: true)
    }
    
    @IBAction func projectTapped(_ sender: UIButton) {
        let projectVC = ProjectViewController.instantiate(from: .project)
        navigationController?.pushViewController(projectVC, animated: true)
    }
    
    
    @IBAction func buildResumeTapped(_ sender: UIButton) {
        guard let userModel = userModel else { return }
        self.showLoading(true)
        PDFCreator().createResume(userModel: userModel) { [weak self] url, error in
            guard let self = self else { return }
            self.showLoading(false)
            guard error == nil else { return }
            if let url = url {
                let pdfReviewer = PDFReviewerViewController.instantiate(from: .pdfReviewer)
                pdfReviewer.url = url
                self.navigationController?.pushViewController(pdfReviewer, animated: true)
            }
        }
    }
    
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        let changePasswordVC = ChangePasswordViewController.instantiate(from: .authentication)
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        
        alert(message: "Are you sure you want to logout?", actions: [("Yes", .default, {_ in self.performLogout()}), ("Cancel", .default, nil)])
        
    }
    
    private func performLogout() {
        AuthenticationRepoImpl().signout { [weak self] error in
            if error != nil {
                self?.alert(message: error!.localizedDescription, actions: [("OK", .default, nil)])
            } else {
                self?.dismiss(animated: true)
            }
        }
    }

    
}
