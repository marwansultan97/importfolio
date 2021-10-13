//
//  ProjectViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 29/09/2021.
//

import UIKit
import Lottie
import Firebase

class ProjectViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    private let projectCellID = "ProjectTableViewCell"
    private let viewModel = ProjectViewModel(meRepo: MeRepoImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        viewModelBinding()
        viewModel.getUserProjects()
    }
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }

        viewModel.didReceiveProjects = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.projects.isEmpty {
                self.tableView.alpha = 0
                self.animationView.isHidden = false
                self.animationView.play()
            }
            else {
                if self.animationView.isAnimationPlaying {
                    self.animationView.stop()
                }
                self.animationView.isHidden = true
                self.tableView.alpha = 1
                self.tableView.reloadData()
            }
        }
        
        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoading ? self.showLoading(true) : self.showLoading(false)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: projectCellID, bundle: nil), forCellReuseIdentifier: projectCellID)
    }
    
    private func setupViews() {
        let addButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = addButton
        
        animationView.animation = Animation.named("empty", bundle: Bundle.main)
        animationView.animationSpeed = 1
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
    }
    
    @objc func handleAdd() {
        let addProjectVC = AddProjectViewController.instantiate(from: .project)
        let newProjectModel = ProjectModel(id: UUID().uuidString, name: "", appImage: "", category: "", description: "", technologies: "", github: "")
        addProjectVC.delegate = self
        addProjectVC.projectModel = newProjectModel
        self.present(addProjectVC, animated: true)
    }

}

extension ProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: projectCellID, for: indexPath) as! ProjectTableViewCell
        cell.configureCell(project: viewModel.projects[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let details = ProjectDetailsViewController.instantiate(from: .project)
            details.delegate = self
            details.email = Auth.auth().currentUser?.email?.replaceDotWithComma()
            details.projectModel = self.viewModel.projects[indexPath.row]
            self.present(details, animated: true)
        }
    }
    
}

extension ProjectViewController: ProjectDetailsDelegate {
    
    func didSaveSuccessfully() {
        viewModel.getUserProjects()
    }
    
}

extension ProjectViewController: AddProjectViewControllerDelegate {
    
    func didAddSuccessfully() {
        viewModel.getUserProjects()
    }
}
