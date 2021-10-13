//
//  UserViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 05/10/2021.
//

import UIKit
import SABlurImageView

class UserViewController: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var jobLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var linkedinView: UIView!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var linkedinHeight: NSLayoutConstraint!
        
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobilelLabel: UILabel!
    @IBOutlet weak var linkedinLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    @IBOutlet weak var educationTableView: UITableView!
    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var skillTableView: UITableView!
    @IBOutlet weak var projectTableView: UITableView!
    
    
    @IBOutlet weak var educationTableHeight: NSLayoutConstraint!
    @IBOutlet weak var experienceTableHeight: NSLayoutConstraint!
    @IBOutlet weak var skillsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var projectTableViewHeight: NSLayoutConstraint!
    
    
    //MARK: - Variables
    private let skillCellID = "SkillTableViewCell"
    private let experienceCellID = "ExperienceTableViewCell"
    private let educationCellID = "EducationTableViewCell"
    private let projectCellID = "ProjectTableViewCell"
    private let viewModel = UserViewModel(userRepo: UserRepoImpl())
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableViews()
        viewModelBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        educationTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        experienceTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        skillTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        projectTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        educationTableView.removeObserver(self, forKeyPath: "contentSize")
        experienceTableView.removeObserver(self, forKeyPath: "contentSize")
        skillTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if let object = object as? UITableView {
                if object == educationTableView {
                    if let newValue = change?[.newKey] {
                        let newSize = newValue as! CGSize
                        educationTableHeight.constant = newSize.height
                    }
                } else if object == experienceTableView {
                    if let newValue = change?[.newKey] {
                        let newSize = newValue as! CGSize
                        experienceTableHeight.constant = newSize.height
                    }
                } else if object == skillTableView {
                    if let newValue = change?[.newKey] {
                        let newSize = newValue as! CGSize
                        skillsTableHeight.constant = newSize.height
                    }
                } else if object == projectTableView {
                    if let newValue = change?[.newKey] {
                        let newSize = newValue as! CGSize
                        projectTableViewHeight.constant = newSize.height
                    }
                }
            }
        }
    }

    
    private func viewModelBinding() {

        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }

        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            self.scrollView.alpha = self.viewModel.isLoading ? 0 : 1
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }

        viewModel.didReceiveUser = { [weak self] in
            guard let self = self, let user = self.viewModel.user else { return }
            self.nameLbl.text = user.personalInfo.fullname
            self.countryLbl.text = "\(user.personalInfo.country) \(user.personalInfo.city ?? "")"

            if user.personalInfo.linkedin == nil || user.personalInfo.linkedin == "" {
                self.linkedinView.alpha = 0
                self.linkedinHeight.constant = 0
            } else {
                self.linkedinView.alpha = 1
                self.linkedinHeight.constant = 25
            }
            if user.personalInfo.jobTitle == nil || user.personalInfo.jobTitle == "" { self.jobLabelHeight.constant = 0 }
            else { self.jobLabelHeight.constant = 25 }
            self.profileImageView.kf.setImage(with: URL(string: user.personalInfo.image ?? ""), options: [.transition(.fade(1)), .cacheOriginalImage])
            self.jobLbl.text = user.personalInfo.jobTitle
            self.emailLabel.text = user.personalInfo.email
            self.mobilelLabel.text = user.personalInfo.phone
            self.linkedinLabel.text = user.personalInfo.linkedin
            self.summaryLabel.text = user.personalInfo.summary
            self.skillTableView.reloadData()
            self.educationTableView.reloadData()
            self.experienceTableView.reloadData()
            self.projectTableView.reloadData()
        }
        
        guard let email = self.email else { return }
        viewModel.getUserInfos(email: email)
        viewModel.getUserEducations(email: email)
        viewModel.getUserExperiences(email: email)
        viewModel.getUserSkills(email: email)
        viewModel.getUserProjects(email: email)

    }

    
    private func setupViews() {
        profileImageView.makeShadowsAndCorners(cornerRadius: 40, shadowOpacity: 2, shadowOffset: .zero, shadowRadius: 2, shadowColor: .white)
        profileImageView.makeBorders(borderWidth: 1, borderColor: .white)
    }
    
    private func setupTableViews() {
        educationTableView.delegate = self
        educationTableView.dataSource = self
        educationTableView.tableFooterView = UIView()
        educationTableHeight.constant = 0
        educationTableView.register(UINib(nibName: educationCellID, bundle: nil), forCellReuseIdentifier: educationCellID)
        
        experienceTableView.delegate = self
        experienceTableView.dataSource = self
        experienceTableView.tableFooterView = UIView()
        experienceTableHeight.constant = 0
        experienceTableView.register(UINib(nibName: experienceCellID, bundle: nil), forCellReuseIdentifier: experienceCellID)
        
        skillTableView.delegate = self
        skillTableView.dataSource = self
        skillTableView.tableFooterView = UIView()
        skillsTableHeight.constant = 0
        skillTableView.register(UINib(nibName: skillCellID, bundle: nil), forCellReuseIdentifier: skillCellID)
        
        projectTableView.delegate = self
        projectTableView.dataSource = self
        projectTableView.tableFooterView = UIView()
        projectTableViewHeight.constant = 0
        projectTableView.register(UINib(nibName: projectCellID, bundle: nil), forCellReuseIdentifier: projectCellID)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == educationTableView { return viewModel.educations.count }
        else if tableView == experienceTableView { return viewModel.experiences.count }
        else if tableView == projectTableView { return viewModel.projects.count }
        else { return viewModel.skills.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == educationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: educationCellID, for: indexPath) as! EducationTableViewCell
            cell.configureCell(educationModel: viewModel.educations[indexPath.row])
            return cell
        }
        else if tableView == experienceTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: experienceCellID, for: indexPath) as! ExperienceTableViewCell
            cell.configureCell(experienceModel: viewModel.experiences[indexPath.row])
            return cell
        }
        else if tableView == projectTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: projectCellID, for: indexPath) as! ProjectTableViewCell
            cell.configureCell(project: viewModel.projects[indexPath.row])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: skillCellID, for: indexPath) as! SkillTableViewCell
            cell.skillLabel.text = viewModel.skills[indexPath.row].skill
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == projectTableView {
            DispatchQueue.main.async {
                let details = ProjectDetailsViewController.instantiate(from: .project)
                details.email = self.viewModel.userInfo.email.replaceDotWithComma()
                details.projectModel = self.viewModel.projects[indexPath.row]
                self.present(details, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == educationTableView { return 110 }
        else if tableView == experienceTableView { return 200 }
        else if tableView == projectTableView { return 70 }
        else { return 20 }
    }
    
}
