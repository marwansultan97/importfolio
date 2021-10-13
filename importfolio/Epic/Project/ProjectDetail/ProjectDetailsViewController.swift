//
//  ProjectDetailsViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 29/09/2021.
//

import UIKit
import Kingfisher
import SwiftyMenu
import Firebase

protocol ProjectDetailsDelegate {
    func didSaveSuccessfully()
}

class ProjectDetailsViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var changerImageButton: UIButton!
    @IBOutlet weak var projectNameTF: UITextField!
    @IBOutlet weak var projectLinkTF: UITextField!
    @IBOutlet weak var projectCategoryDD: SwiftyMenu!
    @IBOutlet weak var projectDescTV: UITextView!
    @IBOutlet weak var techTF: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
        
    private let imageCellID = "ImageTableViewCell"
    private let viewModel = ProjectDetailsViewModel(meRepo: MeRepoImpl(), projectsRepo: ProjectsRepoImpl())
    
    var delegate: ProjectDetailsDelegate?
    var projectModel: ProjectModel?
    var email: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        viewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let object = object as? UITableView {
                if object == tableView {
                    if let newValue = change?[.newKey] {
                        let newSize = newValue as! CGSize
                        tableViewHeight.constant = newSize.height
                    }
                }
            }
        }
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
        
        viewModel.didSuccessfullyRefreshed = { [weak self] in
            guard let self = self, let model = self.viewModel.projectModel else { return }
            self.projectModel = model
            self.setupData()
            self.tableView.reloadData()
            
        }
        
        viewModel.didSuccessfullySaved = { [weak self] in
            guard let self = self, let model = self.viewModel.projectModel, let email = self.email else { return }
            self.viewModel.refreshProjectData(email: email, project: model)
            self.delegate?.didSaveSuccessfully()
        }
        
        viewModel.didReceiveImages = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.didSuccessfullyDeleted = { [weak self] in
            guard let self = self else { return }
            self.showDone(animationType: .deleted) {
                self.delegate?.didSaveSuccessfully()
                self.dismiss(animated: true)
            }
        }
        
        if let project = projectModel, let email = email {
            viewModel.refreshProjectData(email: email, project: project)
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
        
        deleteButton.uniqueCorners(topLeft: 0, topRight: 15, bottomLeft: 40, bottomRight: 0)
        
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
        
        if email != Auth.auth().currentUser?.email?.replaceDotWithComma() {
            deleteButton.alpha = 0
            saveButton.alpha = 0
            addImageButton.alpha = 0
            techTF.isEnabled = false
            projectNameTF.isEnabled = false
            projectLinkTF.isEnabled = false
            projectDescTV.isEditable = false
            projectCategoryDD.isUserInteractionEnabled = false
            
        }
    }
    
    private func setupData() {
        guard let model = projectModel else { return }
        projectImage.kf.setImage(with: URL(string: model.appImage))
        projectNameTF.text = model.name
        techTF.text = model.technologies
        projectCategoryDD.selectedIndex = APP_CATEGORY_LIST.firstIndex(where: { $0 == model.category })
        projectDescTV.text = model.description
        projectLinkTF.text = model.github
        projectImage.kf.setImage(with: URL(string: model.appImage))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: imageCellID, bundle: nil), forCellReuseIdentifier: imageCellID)
    }
    

    
    @IBAction func changeTapped(_ sender: UIButton) {
        guard let projectModel = projectModel else { return }
        ImagePicker.shared.showActionSheet(vc: self)
        ImagePicker.shared.imagePickedBlock = { [weak self] info in
            let image = ImagePicker.shared.getImage(info: info)
            self?.viewModel.changeAppImage(image: image, project: projectModel)
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        showAlert(message: "Are you sure you want to delete this project?",
                  actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        guard let projectModel = self.projectModel else { return }
                        self.viewModel.deleteProject(projectModel: projectModel)
                    }),
                    UIAlertAction(title: "No", style: .default, handler: nil)])
        
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        guard let projectModel = projectModel else { return }
        ImagePicker.shared.showActionSheet(vc: self)
        ImagePicker.shared.imagePickedBlock = { [weak self] info in
            let image = ImagePicker.shared.getImage(info: info)
            let id = UUID().uuidString
            self?.viewModel.addImage(image: image, projectModel: projectModel, id: id)
        }
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard var projectModel = projectModel else { return }
        projectModel.category = projectCategoryDD.selectedIndex == nil ? "" : APP_CATEGORY_LIST[projectCategoryDD.selectedIndex!]
        projectModel.description = projectDescTV.text ?? ""
        projectModel.github = projectLinkTF.text ?? ""
        projectModel.name = projectNameTF.text ?? ""
        projectModel.technologies = techTF.text ?? ""
        viewModel.saveProject(projectModel: projectModel)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension ProjectDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageCellID, for: indexPath) as! ImageTableViewCell
        cell.configureCell(image: viewModel.images[indexPath.row].imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let imageModel = self.viewModel.images[indexPath.row]
            let projectModel = self.viewModel.projectModel
            let previewVC = ImagePreviewViewController.instantiate(from: .project)
            previewVC.imageModel = imageModel
            previewVC.projectModel = projectModel
            previewVC.delegate = self
            previewVC.email = self.email?.replaceDotWithComma()
            previewVC.modalTransitionStyle = .crossDissolve
            previewVC.modalPresentationStyle = .overCurrentContext
            self.present(previewVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension ProjectDetailsViewController: ImagePreviewDelegate {
    func didDeleteImage() {
        if let project = projectModel, let email = email {
            viewModel.refreshProjectData(email: email, project: project)
        }
    }
}

