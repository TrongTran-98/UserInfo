//
//  UserDetailsViewController.swift
//  UserInfo
//

import UIKit
import SnapKit
import Foundation

class UserDetailsViewController: BaseViewController {
    
    var userDetailsViewModel: UserDetailsViewModel? { return viewModel as? UserDetailsViewModel }
    
    // MARK: - Interface Properties
    private let infoContainer = UIView()
    private let userCardView = UserCardView()
    
    private let followerView = FollowView(type: .follower)
    private let followingView = FollowView(type: .following)
    
    private let urlTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    convenience init(loginName: String) {
        self.init(viewModel: UserDetailsViewModel(loginName: loginName))
    }
    
    init(viewModel: UserDetailsViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.userDetailsViewModel?.fetchUserDetails()
    }
    
    // MARK: - Binding
    override func binding() {
        super.binding()
        
        guard let detailViewModel = userDetailsViewModel else { return }
        
        detailViewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoadingIndicatorView()
            } else {
                self.hideLoadingIndicatorView()
            }
        }.store(in: &cancellables)
        
        detailViewModel.$user.receive(on: DispatchQueue.main).sink { [weak self] user in
            guard let self = self else { return }
            self.updateUserInfo(user)
        }.store(in: &cancellables)
    }
    
    // MARK: - Setup View
    private func setupView() {
        navigationItem.title = "User Details"
        
        view.backgroundColor = .white
        view.addSubview(infoContainer)
        infoContainer.snp.makeConstraints({ make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        })
        
        infoContainer.addSubview(userCardView)
        userCardView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
        })
        
        let followStackView = UIStackView()
        followStackView.axis = .horizontal
        followStackView.distribution = .fillEqually
        followStackView.spacing = 16
        
        followStackView.addArrangedSubview(followerView)
        followStackView.addArrangedSubview(followingView)
        
        infoContainer.addSubview(followStackView)
        followStackView.snp.makeConstraints({ make in
            make.top.equalTo(userCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        })
        
        infoContainer.addSubview(urlTitleLabel)
        infoContainer.addSubview(urlLabel)
        
        urlTitleLabel.text = "Blog URL"
        urlTitleLabel.snp.makeConstraints({ make in
            make.top.equalTo(followStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        })
        
        urlLabel.snp.makeConstraints({ make in
            make.top.equalTo(urlTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        })
    }
    
    // MARK: - Update Interface
    private func updateUserInfo(_ user: User?) {
        if let user = user {
            infoContainer.isHidden = false
            userCardView.bind(user)
            followerView.setFollowNumber(count: user.followers)
            followingView.setFollowNumber(count: user.following)
            urlLabel.text = user.htmlUrl
        } else {
            infoContainer.isHidden = true
        }
    }
}
