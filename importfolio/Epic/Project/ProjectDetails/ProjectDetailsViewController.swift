//
//  AddProjectViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 29/09/2021.
//

import UIKit
import SwiftyMenu

protocol ProjectDetailsDelegate {
    func didSaveSuccessfully()
}

class AddProjectViewController: UIViewController, Storyboarded {
    
    
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
    
    var delegate: ProjectDetailsDelegate?
    var projectModel: ProjectModel?
    
    let model = ProjectModel.mockQuadrant

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
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
        
//        deleteButton.alpha = experienceModel?.company == "" ? 0 : 1
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
    }
    
    private func setupData() {
        projectImage.kf.setImage(with: URL(string: model.appImage))
        projectNameTF.text = model.name
        techTF.text = model.technologies
        projectCategoryDD.selectedIndex = APP_CATEGORY_LIST.firstIndex(where: { $0 == model.category })
        projectDescTV.text = model.description
        projectLinkTF.text = model.github
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: imageCellID, bundle: nil), forCellReuseIdentifier: imageCellID)
    }
    

    
    @IBAction func changeTapped(_ sender: UIButton) {
        ImagePicker.shared.showActionSheet(vc: self)
        ImagePicker.shared.imagePickedBlock = { [weak self] info in
            let image = ImagePicker.shared.getImage(info: info)
            // change app image
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        ImagePicker.shared.showActionSheet(vc: self)
        ImagePicker.shared.imagePickedBlock = { [weak self] info in
            let image = ImagePicker.shared.getImage(info: info)
            let id = UUID().uuidString
        }
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
    }
    
    
}

extension AddProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageCellID, for: indexPath) as! ImageTableViewCell
        cell.configureCell(image: model.images[indexPath.row].imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = model.images[indexPath.row]
        let previewVC = ImagePreviewViewController.instantiate(from: .project)
        previewVC.image = image.imageURL
        previewVC.modalTransitionStyle = .crossDissolve
        previewVC.modalPresentationStyle = .overCurrentContext
        present(previewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}

