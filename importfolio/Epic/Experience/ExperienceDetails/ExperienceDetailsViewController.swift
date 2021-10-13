//
//  ExperienceDetailsViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 14/09/2021.
//

import UIKit
import SwiftyMenu

protocol ExperienceDetailsDelegate {
    func didSaveSuccessfully()
}

class ExperienceDetailsViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var jobtitleTF: UITextField!
    @IBOutlet weak var companynameTF: UITextField!
    @IBOutlet weak var toStaticLabel: UILabel!
    @IBOutlet weak var frommonthDD: SwiftyMenu!
    @IBOutlet weak var tomonthDD: SwiftyMenu!
    @IBOutlet weak var yearfromDD: SwiftyMenu!
    @IBOutlet weak var yeartoDD: SwiftyMenu!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentlyBtn: UIButton!
    @IBOutlet weak var presentStaticLabel: UILabel!
    
    private let viewModel = ExperienceDetailsViewModel(meRepo: MeRepoImpl())
    var experienceModel: ExperienceModel?
    var delegate: ExperienceDetailsDelegate?
    

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
        showLoading(true)
        containerView.layer.cornerRadius = 15
        contentView.layer.cornerRadius = 15
        containerView.makeBorders(borderWidth: 0.5, borderColor: .white.withAlphaComponent(0.8))
        
        presentStaticLabel.alpha = 0
        
        jobtitleTF.makeShadowsAndCorners(cornerRadius: 5)
        jobtitleTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        jobtitleTF.setTextHorizontalPadding(10)
        
        companynameTF.makeShadowsAndCorners(cornerRadius: 5)
        companynameTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        companynameTF.setTextHorizontalPadding(10)
        
        descTV.makeShadowsAndCorners(cornerRadius: 5)
        descTV.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        deleteButton.alpha = experienceModel?.company == "" ? 0 : 1
        deleteButton.uniqueCorners(topLeft: 0, topRight: 15, bottomLeft: 40, bottomRight: 0)
        
        var att = SwiftyMenuAttributes().attributes
        att.placeHolderStyle = .value(text: "Select...", textColor: .white.withAlphaComponent(0.7))
        
        frommonthDD.configure(with: att)
        frommonthDD.items = MONTHS
        frommonthDD.didCollapse = {
            self.frommonthDD.heightConstraint.constant = 40
        }
        frommonthDD.didSelectItem = { menu, item, index in
            self.frommonthDD.toggle()
        }
        
        tomonthDD.configure(with: att)
        tomonthDD.items = MONTHS
        tomonthDD.didCollapse = {
            self.tomonthDD.heightConstraint.constant = 40
        }
        tomonthDD.didSelectItem = { menu, item, index in
            self.tomonthDD.toggle()
        }
        
        yearfromDD.configure(with: att)
        yearfromDD.items = YEARS
        yearfromDD.didCollapse = {
            self.yearfromDD.heightConstraint.constant = 40
        }
        yearfromDD.didSelectItem = { menu, item, index in
            self.yearfromDD.toggle()
        }
        
        yeartoDD.configure(with: att)
        yeartoDD.items = YEARS
        yeartoDD.didCollapse = {
            self.yeartoDD.heightConstraint.constant = 40
        }
        yeartoDD.didSelectItem = { menu, item, index in
            self.yeartoDD.toggle()
        }
        
    }
    
    private func setupData() {
        guard let experienceModel = experienceModel else { return }
        companynameTF.text = experienceModel.company
        jobtitleTF.text = experienceModel.title
        descTV.text = experienceModel.description
        currentlyBtn.isSelected = experienceModel.isCurrentlyWorking
        
        frommonthDD.selectedIndex = experienceModel.fromMonth == "" ? nil : MONTHS.firstIndex(where: { $0 == experienceModel.fromMonth })
        yearfromDD.selectedIndex = experienceModel.fromYear == "" ? nil : YEARS.firstIndex(where: { $0 == experienceModel.fromYear })

        toStaticLabel.alpha = experienceModel.isCurrentlyWorking ? 0 : 1
        yeartoDD.alpha = experienceModel.isCurrentlyWorking ? 0 : 1
        tomonthDD.alpha = experienceModel.isCurrentlyWorking ? 0 : 1
        presentStaticLabel.alpha = !experienceModel.isCurrentlyWorking ? 0 : 1
        
        if experienceModel.isCurrentlyWorking {
            tomonthDD.selectedIndex = nil
            yeartoDD.selectedIndex = nil
        } else {
            tomonthDD.selectedIndex = experienceModel.toMonth == "" ? nil : MONTHS.firstIndex(where: { $0 == experienceModel.toMonth })
            yeartoDD.selectedIndex = experienceModel.toYear == "" ? nil : YEARS.firstIndex(where: { $0 == experienceModel.toYear })
        }
        showLoading(false)
        
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    @IBAction func currentyTapped(_ sender: UIButton) {
        
        if currentlyBtn.isSelected {
            experienceModel?.toYear = "Present"
            experienceModel?.toMonth = ""
        } else {
            experienceModel?.toYear = ""
            experienceModel?.toMonth = ""
            yeartoDD.selectedIndex = nil
            tomonthDD.selectedIndex = nil
        }
        
        currentlyBtn.isSelected.toggle()
        experienceModel?.isCurrentlyWorking = currentlyBtn.isSelected
        toStaticLabel.alpha = currentlyBtn.isSelected ? 0 : 1
        yeartoDD.alpha = currentlyBtn.isSelected ? 0 : 1
        tomonthDD.alpha = currentlyBtn.isSelected ? 0 : 1
        presentStaticLabel.alpha = !currentlyBtn.isSelected ? 0 : 1
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard var model = experienceModel else { return }
        model.company = companynameTF.text ?? ""
        model.title = jobtitleTF.text ?? ""
        model.fromMonth = frommonthDD.selectedIndex == nil ? "" : MONTHS[frommonthDD.selectedIndex!]
        model.fromYear = yearfromDD.selectedIndex == nil ? "" : YEARS[yearfromDD.selectedIndex!]
        model.description = descTV.text ?? ""
        if model.isCurrentlyWorking {
            model.toMonth = ""
            model.toYear = "Present"
        } else {
            model.toMonth = tomonthDD.selectedIndex == nil ? "" : MONTHS[tomonthDD.selectedIndex!]
            model.toYear = yeartoDD.selectedIndex == nil ? "" : YEARS[yeartoDD.selectedIndex!]
        }
        viewModel.saveExperienceDetails(experienceModel: model)
    }
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        showAlert(message: "Are you sure you want to delete this skill?",
                  actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        guard let experienceModel = self.experienceModel else { return }
                        self.viewModel.deleteExperience(experienceModel: experienceModel)
                    }),
                    UIAlertAction(title: "No", style: .default, handler: nil)])
    }
    
    
    
    
}
