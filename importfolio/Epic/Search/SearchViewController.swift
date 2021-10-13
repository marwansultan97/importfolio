//
//  SearchViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 05/10/2021.
//

import UIKit

class SearchViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var noMatchLabel: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    private let viewModel = SearchViewModel(userRepo: UserRepoImpl())
    private let cellID = "UserTableViewCell"
    private var debouncer: Debouncer!
    
    private var textValue: String = "" {
        didSet {
            debouncer.call()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        viewModelBinding()                
    }
        
    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        userView.makeShadowsAndCorners(cornerRadius: 8)
        userView.makeBorders(borderWidth: 1, borderColor: .white)
        userView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserProfile)))
        noMatchLabel.alpha = 0
        emailLabel.adjustsFontSizeToFitWidth = true
        userImageView.layer.cornerRadius = 8
        userViewHeight.constant = 0
        userView.alpha = 0
        clearButton.alpha = 0.5
        clearButton.isEnabled = false
        debouncer = Debouncer(delay: 0.5, callback: {
            self.debouncerCall()
        })
        
    }

    
    private func debouncerCall() {
        guard !textValue.isEmpty else { return }
        viewModel.isLoading = false
        viewModel.searchUser(email: textValue.replaceDotWithComma())
    }
    
    private func viewModelBinding() {
        
        viewModel.didReceiveError = { [weak self] in
            guard let self = self, let error = self.viewModel.errorMessage else { return }
            self.showAlert(message: error, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
        
        viewModel.didReceiveIsLoading = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.isLoading { self.noMatchLabel.alpha = 0 }
            self.viewModel.isLoading ? self.showLoadingWithoutOverlay(true) : self.showLoadingWithoutOverlay(false)
        }
        
        viewModel.didReceiveInfo = { [weak self] in
            guard let self = self, let info = self.viewModel.searchedInfo else { return }
            self.noMatchLabel.alpha = 0
            self.nameLabel.text = info.fullname
            self.jobLabel.text = info.jobTitle
            self.emailLabel.text = info.email
            self.userImageView.kf.setImage(with: URL(string: info.image ?? ""), placeholder: UIImage(named: "avatar"), options: [.transition(.fade(0.5))])
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.userView.alpha = 1
                self.userViewHeight.constant = 100
                self.view.layoutIfNeeded()
            }
        }
        
        viewModel.didReceiveEmptyInfo = { [weak self] in
            guard let self = self, self.viewModel.isEmptyInfo == true else { return }
            self.noMatchLabel.alpha = 1
            self.nameLabel.text = ""
            self.jobLabel.text = ""
            self.emailLabel.text = ""
            self.userImageView.image = UIImage()
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.userView.alpha = 0
                self.userViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func openUserProfile() {
        guard let email = viewModel.searchedInfo?.email else { return }
        let userVC = UserViewController.instantiate(from: .user)
        userVC.email = email.replaceDotWithComma()
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    
    @IBAction func clearTapped(_ sender: UIButton) {
        searchTF.text = ""
        textValue = ""
        noMatchLabel.alpha = 0
        clearButton.alpha = 0.5
        clearButton.isEnabled = false
        viewModel.isLoading = false
        nameLabel.text = ""
        jobLabel.text = ""
        emailLabel.text = ""
        userImageView.image = UIImage()
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.userView.alpha = 0
            self.userViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func searchChanged(_ sender: UITextField) {
        if sender.text == nil || sender.text == "" {
            clearButton.alpha = 0.5
            clearButton.isEnabled = false
        } else {
            clearButton.alpha = 1
            clearButton.isEnabled = true
        }
        textValue = sender.text ?? ""
    }
    
}
