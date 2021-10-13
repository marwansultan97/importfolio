//
//  HomeViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 03/09/2021.
//

import UIKit
import Firebase
import Lottie
import SABlurImageView
import SwiftMessages

class HomeViewController: UIViewController, Storyboarded {

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
    @IBOutlet weak var coverImageView: SABlurImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var collapsingView: SimpleCollapsingHeaderView!
    
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

    
    private let viewModel = HomeViewModel(meRepo: MeRepoImpl())
    
    var swiftyMessageShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupViews()
        setupTableViews()
        viewModelBinding()
        
    }
    
    override func viewDidLayoutSubviews() {
        collapsingView.roundCorners(corners: [.bottomLeft], radius: 40)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getUserInfo()
        viewModel.getUserEducations()
        viewModel.getUserExperiences()
        viewModel.getUserSkills()
        viewModel.getUserProject()
        navigationController?.navigationBar.isHidden = false
        educationTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        experienceTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        skillTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        projectTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        educationTableView.removeObserver(self, forKeyPath: "contentSize")
        experienceTableView.removeObserver(self, forKeyPath: "contentSize")
        skillTableView.removeObserver(self, forKeyPath: "contentSize")
        SwiftMessages.hideAll()
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
            if user.personalInfo.jobTitle == nil || user.personalInfo.jobTitle == "" { self.jobLabelHeight.constant = 0
                if !self.swiftyMessageShown { self.showSwiftyMessage() ; self.swiftyMessageShown.toggle() }
            }
            else { self.jobLabelHeight.constant = 25 }

            self.profileImageView.kf.setImage(with: URL(string: user.personalInfo.image ?? ""), placeholder: UIImage(named: "avatar"), options: [.transition(.fade(1)), .cacheOriginalImage])
            self.coverImageView.kf.setImage(with: URL(string: user.personalInfo.image ?? ""), placeholder: UIImage(named: "default1"), options: [.transition(.fade(1)), .cacheOriginalImage]) { _ in
                self.coverImageView.addBlurEffect(50, times: 10)
            }
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
        
    }

    
    private func setupViews() {
        let searchButton = UIBarButtonItem(image: UIImage(named: "magnifyingglass.circle.fill"), style: .plain, target: self, action: #selector(openSearch))
        let profileButton = UIBarButtonItem(image: UIImage(named: "person.circle.fill"), style: .plain, target: self, action: #selector(openProfile))
        navigationItem.rightBarButtonItems = [searchButton,profileButton]
        
        profileImageView.makeShadowsAndCorners(cornerRadius: 40, shadowOpacity: 0, shadowOffset: .zero, shadowRadius: 0, shadowColor: .clear)
        profileImageView.makeBorders(borderWidth: 1, borderColor: .white)
        coverImageView.addBlurEffect(50, times: 10)
        scrollView.delegate = self
        collapsingView.delegate = self
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
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    @objc func openProfile() {
        let profileVC = ProfileViewController.instantiate(from: .profile)
        profileVC.userModel = viewModel.user
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func openSearch() {
        let searchVC = SearchViewController.instantiate(from: .search)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func showSwiftyMessage() {
        var config = SwiftMessages.Config()
        config.duration = .forever
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .statusBar)
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.info)
        view.configureContent(title: "Welcome", body: "Help others to know you better", iconText: "🌟")
        view.configureDropShadow()
        view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20)
        view.button?.backgroundColor = .appColor
        view.button?.setTitle("Go", for: .normal)
        view.buttonTapHandler = { _ in
            SwiftMessages.hide()
            let profileVC = ProfileViewController.instantiate(from: .profile)
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        
        SwiftMessages.show(config: config, view: view)
    }
  
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        collapsingView.collapseHeaderView(using: scrollView)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension HomeViewController: SimpleCollapsingHeaderViewDelegate {
    
    func onHeaderDidAnimate(with percentage: CGFloat) {
        
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = "Marwan Osama"
        let textWidth = (myText as NSString).size(withAttributes: fontAttributes).width / 2

        let scaleEffect = 1 - ((1-percentage)*0.45)
        let scale = CGAffineTransform(scaleX: scaleEffect, y: scaleEffect)
        let move = CGAffineTransform(translationX: 30 * (percentage - 1), y: 60 * (1 - percentage))
        profileImageView.transform = scale.concatenating(move)
        nameLbl.transform = CGAffineTransform(translationX: ((SCREEN_WIDTH/2) - textWidth - 40) * (1 - percentage), y: (percentage - 1))
        
    }
    
}
