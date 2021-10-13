//
//  EducationViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 13/09/2021.
//

import UIKit
import Lottie

class EducationViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    private let educationCellID = "EducationTableViewCell"
    private let viewModel = EducationViewModel(meRepo: MeRepoImpl())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViews()
        viewModelBinding()
        viewModel.getUserEducations()
    }
    
    private func viewModelBinding() {
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }

        viewModel.didReceiveEducations = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.educations.isEmpty {
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
        tableView.register(UINib(nibName: educationCellID, bundle: nil), forCellReuseIdentifier: educationCellID)
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
        let details = EducationDetailsViewController.instantiate(from: .education)
        let newEducationModel = EducationModel(id: UUID().uuidString, university: "", degreeLevel: "", studyField: "", from: "", to: "", grade: nil)
        details.delegate = self
        details.educationModel = newEducationModel
        self.present(details, animated: true)
    }
    
}

extension EducationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.educations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: educationCellID, for: indexPath) as! EducationTableViewCell
        cell.configureCell(educationModel: viewModel.educations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
            let educationDetailsVC = EducationDetailsViewController.instantiate(from: .education)
            educationDetailsVC.delegate = self
            educationDetailsVC.educationModel = self.viewModel.educations[indexPath.row]
            self.present(educationDetailsVC, animated: true)
        }
        
    }
    
    
}

extension EducationViewController: EducationDetailsDelegate {
    
    func didSuccessfullySaved() {
        viewModel.getUserEducations()
    }
}
