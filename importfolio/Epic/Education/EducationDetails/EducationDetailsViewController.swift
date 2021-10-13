//
//  EducationDetailsViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 14/09/2021.
//

import UIKit
import SwiftyMenu

protocol EducationDetailsDelegate {
    func didSuccessfullySaved()
}

class EducationDetailsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var degreeDD: SwiftyMenu!
    @IBOutlet weak var startyearDD: SwiftyMenu!
    @IBOutlet weak var endyearDD: SwiftyMenu!
    @IBOutlet weak var gradeDD: SwiftyMenu!
    @IBOutlet weak var universityTF: UITextField!
    @IBOutlet weak var fieldsTF: UITextField!
    
    
    private let viewModel = EducationDetailsViewModel(meRepo: MeRepoImpl())
    
    var educationModel: EducationModel?
    var delegate: EducationDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewModelBinding()

    }

    override func viewDidAppear(_ animated: Bool) {
        setupData()
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
                self.delegate?.didSuccessfullySaved()
                self.dismiss(animated: true)
            }
        }
        
        viewModel.didSuccessfullydeleted = { [weak self] in
            guard let self = self else { return }
            self.showDone(animationType: .deleted) {
                self.delegate?.didSuccessfullySaved()
                self.dismiss(animated: true)
            }
        }
    }
    
    private func setupViews() {
        showLoading(true)
        containerView.layer.cornerRadius = 15
        contentView.layer.cornerRadius = 15
        containerView.makeBorders(borderWidth: 0.5, borderColor: .white.withAlphaComponent(0.8))
        
        universityTF.makeShadowsAndCorners(cornerRadius: 5)
        universityTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        universityTF.setTextHorizontalPadding(10)
        
        fieldsTF.makeShadowsAndCorners(cornerRadius: 5)
        fieldsTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        fieldsTF.setTextHorizontalPadding(10)
        
        deleteButton.alpha = educationModel?.degreeLevel == "" ? 0 : 1
        deleteButton.uniqueCorners(topLeft: 0, topRight: 15, bottomLeft: 40, bottomRight: 0)
                
        var att = SwiftyMenuAttributes().attributes
        att.placeHolderStyle = .value(text: "Select...", textColor: .white.withAlphaComponent(0.7))
        
        degreeDD.configure(with: att)
        degreeDD.items = DEGREE_LEVELS
        degreeDD.didCollapse = {
            self.degreeDD.heightConstraint.constant = 40
        }
        degreeDD.didSelectItem = { menu, item, index in
            self.degreeDD.toggle()
        }
        
        startyearDD.configure(with: att)
        startyearDD.items = YEARS
        startyearDD.didCollapse = {
            self.startyearDD.heightConstraint.constant = 40
        }
        startyearDD.didSelectItem = { menu, item, index in
            self.startyearDD.toggle()
        }
        
        endyearDD.configure(with: att)
        endyearDD.items = YEARS
        endyearDD.didCollapse = {
            self.endyearDD.heightConstraint.constant = 40
        }
        endyearDD.didSelectItem = { menu, item, index in
            self.endyearDD.toggle()
        }
        
        gradeDD.configure(with: att)
        gradeDD.items = GRADES
        gradeDD.didCollapse = {
            self.gradeDD.heightConstraint.constant = 40
        }
        gradeDD.didSelectItem = { menu, item, index in
            self.gradeDD.toggle()
        }
    }
    
    func setupData() {
        guard let educationModel = educationModel else { return }
        degreeDD.selectedIndex = educationModel.degreeLevel == "" ? nil : DEGREE_LEVELS.firstIndex(where: { $0 == educationModel.degreeLevel })
        startyearDD.selectedIndex = educationModel.from == "" ? nil : YEARS.firstIndex(where: { $0 == educationModel.from })
        endyearDD.selectedIndex = educationModel.to == "" ? nil : YEARS.firstIndex(where: { $0 == educationModel.to })
        gradeDD.selectedIndex = educationModel.grade == nil ? nil : GRADES.firstIndex(where: { $0 == educationModel.grade })
        fieldsTF.text = educationModel.studyField
        universityTF.text = educationModel.university
        showLoading(false)
    }
    

    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard var educationModel = educationModel else { return }
        educationModel.degreeLevel = degreeDD.selectedIndex == nil ? "" : DEGREE_LEVELS[degreeDD.selectedIndex!]
        educationModel.studyField = fieldsTF.text ?? ""
        educationModel.from = startyearDD.selectedIndex == nil ? "" : YEARS[startyearDD.selectedIndex!]
        educationModel.to = endyearDD.selectedIndex == nil ? "" : YEARS[endyearDD.selectedIndex!]
        educationModel.university = universityTF.text ?? ""
        educationModel.grade = gradeDD.selectedIndex == nil ? nil : GRADES[gradeDD.selectedIndex!]
        viewModel.saveEducationDetails(educationModel: educationModel)
    }
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        showAlert(message: "Are you sure you want to delete this skill?",
                  actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        guard let educationModel = self.educationModel else { return }
                        self.viewModel.deleteEducation(educationModel: educationModel)
                    }),
                    UIAlertAction(title: "No", style: .default, handler: nil)])
        
        
    }
    
}

extension EducationDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = gestureRecognizer.view else { return false}
        let touchLocation = touch.location(in: view)
        return !containerView.frame.contains(touchLocation)
    }
}
