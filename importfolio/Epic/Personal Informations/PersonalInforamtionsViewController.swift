//
//  PersonalInforamtionsViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 13/09/2021.
//

import UIKit
import SwiftyMenu
import Firebase
import Kingfisher

class PersonalInforamtionsViewController: UIViewController, Storyboarded {

    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var nationalityDD: SwiftyMenu!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var dayDD: SwiftyMenu!
    @IBOutlet weak var monthDD: SwiftyMenu!
    @IBOutlet weak var yearDD: SwiftyMenu!
    @IBOutlet weak var genderDD: SwiftyMenu!
    @IBOutlet weak var linkedinTF: UITextField!
    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var summaryTV: UITextView!
    
    
    private let viewModel = PersonalInformationViewModel(meRepo: MeRepoImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewModelBinding()
        viewModel.getUserInfo()
        
    }
    
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }

        viewModel.didReceiveProfile = { [weak self] in
            guard let self = self,
                  let profile = self.viewModel.profile else { return }
            self.profileImageView.kf.setImage(with: URL(string: profile.image ?? ""), placeholder: UIImage(named: "avatar"), options: [.transition(.fade(1)), .cacheOriginalImage])
            self.emailTF.text = profile.email
            self.cityTF.text = profile.city ?? ""
            self.fullnameTF.text = profile.fullname
            self.mobileTF.text = profile.phone
            self.linkedinTF.text = profile.linkedin ?? ""
            self.jobTitleTF.text = profile.jobTitle ?? ""
            self.summaryTV.text = profile.summary ?? ""
            self.genderDD.selectedIndex = GENDERS.firstIndex(where: { $0 == profile.gender })
            self.nationalityDD.selectedIndex = COUNTRY_LIST.firstIndex(where: { $0 == profile.country })
            self.dayDD.selectedIndex = DAYS.firstIndex(where: { $0 == profile.day })
            self.monthDD.selectedIndex = MONTHS.firstIndex(where: { $0 == profile.month })
            self.yearDD.selectedIndex = YEARS.firstIndex(where: { $0 == profile.year })
        }
        
        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }
        
        viewModel.didUpdateInfos = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.isUpdated { self.viewModel.getUserInfo() }
            
        }
    }
    
    private func setupViews() {
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector((handleSave)))
        navigationItem.rightBarButtonItem = saveButton
        
        emailTF.makeShadowsAndCorners(cornerRadius: 5)
        emailTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        fullnameTF.makeShadowsAndCorners(cornerRadius: 5)
        fullnameTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        cityTF.makeShadowsAndCorners(cornerRadius: 5)
        cityTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        mobileTF.makeShadowsAndCorners(cornerRadius: 5)
        mobileTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        linkedinTF.makeShadowsAndCorners(cornerRadius: 5)
        linkedinTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        jobTitleTF.makeShadowsAndCorners(cornerRadius: 5)
        jobTitleTF.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        summaryTV.makeShadowsAndCorners(cornerRadius: 5)
        summaryTV.makeBorders(borderWidth: 0.8, borderColor: .white.withAlphaComponent(0.8))
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.makeBorders(borderWidth: 1, borderColor: .white)
        
        var nationalityAtt = SwiftyMenuAttributes().attributes
        nationalityAtt.placeHolderStyle = .value(text: "Choose your country", textColor: .white.withAlphaComponent(0.7))
        

        var dayAtt = SwiftyMenuAttributes().attributes
        dayAtt.placeHolderStyle = .value(text: "Day", textColor: .white.withAlphaComponent(0.7))
        
        var monthAtt = SwiftyMenuAttributes().attributes
        monthAtt.placeHolderStyle = .value(text: "Month", textColor: .white.withAlphaComponent(0.7))
        
        var yearAtt = SwiftyMenuAttributes().attributes
        yearAtt.placeHolderStyle = .value(text: "Year", textColor: .white.withAlphaComponent(0.7))
        
        var genderAtt = SwiftyMenuAttributes().attributes
        genderAtt.placeHolderStyle = .value(text: "Gender", textColor: .white.withAlphaComponent(0.7))

        
        nationalityDD.configure(with: nationalityAtt)
        nationalityDD.items = COUNTRY_LIST
        nationalityDD.didCollapse = {
            self.nationalityDD.heightConstraint.constant = 40
        }
        nationalityDD.didSelectItem = { menu, item, index in
            self.nationalityDD.toggle()
        }
        
        dayDD.configure(with: dayAtt)
        dayDD.items = DAYS
        dayDD.didCollapse = {
            self.dayDD.heightConstraint.constant = 40
        }
        dayDD.didSelectItem = { menu, item, index in
            self.dayDD.toggle()
        }
        
        monthDD.configure(with: monthAtt)
        monthDD.items = MONTHS
        monthDD.didCollapse = {
            self.monthDD.heightConstraint.constant = 40
        }
        monthDD.didSelectItem = { menu, item, index in
            self.monthDD.toggle()
        }
        
        yearDD.configure(with: yearAtt)
        yearDD.items = YEARS
        yearDD.didCollapse = {
            self.yearDD.heightConstraint.constant = 40
        }
        yearDD.didSelectItem = { menu, item, index in
            self.yearDD.toggle()
        }
        
        genderDD.configure(with: genderAtt)
        genderDD.items = GENDERS
        genderDD.didCollapse = {
            self.genderDD.heightConstraint.constant = 40
        }
        genderDD.didSelectItem = { menu, item, index in
            self.genderDD.toggle()
        }
        
        
    }
    
    @objc func handleSave() {
        let email = emailTF.text!
        let city = cityTF.text ?? nil
        let fullname = fullnameTF.text!
        let phone = mobileTF.text!
        let linkedin = linkedinTF.text ?? nil
        let jobTitle = jobTitleTF.text ?? nil
        let summary = summaryTV.text ?? nil
        let country: String = COUNTRY_LIST[nationalityDD.selectedIndex!]
        let gender = genderDD.selectedIndex == nil ? nil : GENDERS[genderDD.selectedIndex!]
        let day = dayDD.selectedIndex == nil ? nil : DAYS[dayDD.selectedIndex!]
        let month = monthDD.selectedIndex == nil ? nil : MONTHS[monthDD.selectedIndex!]
        let year = yearDD.selectedIndex == nil ? nil : YEARS[yearDD.selectedIndex!]
        
        let model = PersonalInfosModel(fullname: fullname, email: email, country: country, jobTitle: jobTitle, summary: summary, gender: gender, phone: phone, linkedin: linkedin, city: city, day: day, month: month, year: year)
        viewModel.updateInfo(personalInfo: model)
    }
    
    @IBAction func imagePickerTapped(_ sender: UIButton) {
        ImagePicker.shared.showActionSheet(vc: self)
        ImagePicker.shared.imagePickedBlock = { [weak self] info in
            let image = ImagePicker.shared.getImage(info: info)
            self?.viewModel.updateUserImage(image: image)
        }
    }
    

}
