//
//  SkillViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 14/09/2021.
//

import UIKit
import Lottie

class SkillViewController: UIViewController, Storyboarded {

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SkillViewModel(meRepo: MeRepoImpl())
    private let skillCellID = "SkillTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        viewModelBinding()
        viewModel.getUserSkills()
    }
    
    private func viewModelBinding() {
        
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }

        viewModel.didReceiveSkills = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.skills.isEmpty {
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
        tableView.register(UINib(nibName: skillCellID, bundle: nil), forCellReuseIdentifier: skillCellID)
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
        let details = SkillDetailsViewController.instantiate(from: .skill)
        let newSkillModel = SkillModel(id: UUID().uuidString, skill: "")
        details.delegate = self
        details.skillModel = newSkillModel
        self.present(details, animated: true)
    }

}

extension SkillViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: skillCellID, for: indexPath) as! SkillTableViewCell
        cell.skillLabel.font = .systemFont(ofSize: 18)
        cell.skillLabel.text = viewModel.skills[indexPath.row].skill
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
            let details = SkillDetailsViewController.instantiate(from: .skill)
            details.delegate = self
            details.skillModel = self.viewModel.skills[indexPath.row]
            self.present(details, animated: true)
        }
    }
    
}

extension SkillViewController: SkillDetailsDelegate {
    func didSaveSuccessfully() {
        viewModel.getUserSkills()
    }
    
}

