//
//  ExperienceViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 14/09/2021.
//

import UIKit
import Lottie

class ExperienceViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    private let experienceCellID = "ExperienceTableViewCell"
    private let viewModel = ExperienceViewModel(meRepo: MeRepoImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViews()
        viewModelBinding()
        viewModel.getUserExperiences()
    }
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }

        viewModel.didReceiveExperiences = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.experiences.isEmpty {
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
        tableView.register(UINib(nibName: experienceCellID, bundle: nil), forCellReuseIdentifier: experienceCellID)
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
        let details = ExperienceDetailsViewController.instantiate(from: .experience)
        let newExperienceModel = ExperienceModel(id: UUID().uuidString, title: "", company: "", description: "", fromMonth: "", fromYear: "", toMonth: "", toYear: "", isCurrentlyWorking: false)
        details.delegate = self
        details.experienceModel = newExperienceModel
        self.present(details, animated: true)
    }
    

}

extension ExperienceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: experienceCellID, for: indexPath) as! ExperienceTableViewCell
        cell.configureCell(experienceModel: viewModel.experiences[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
            let experienceDetailsVC = ExperienceDetailsViewController.instantiate(from: .experience)
            experienceDetailsVC.delegate = self
            experienceDetailsVC.experienceModel = self.viewModel.experiences[indexPath.row]
            self.present(experienceDetailsVC, animated: true)
        }
    }
    
    
}

extension ExperienceViewController: ExperienceDetailsDelegate {
    
    func didSaveSuccessfully() {
        viewModel.getUserExperiences()
    }
}
