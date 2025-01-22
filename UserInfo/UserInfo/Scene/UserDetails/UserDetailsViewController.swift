//
//  UserDetailsViewController.swift
//  UserInfo
//

import UIKit
import SnapKit
import Foundation

class UserDetailsViewController: BaseViewController {
    
    var userDetailsViewModel: UserDetailsViewModel? { return viewModel as? UserDetailsViewModel }
    
    private let infoContainer = UIView()
    // Card view
    private let userCardView = UserCardView()
    // Follow view
    private let followerView = FollowView(type: .follower)
    private let followingView = FollowView(type: .following)
    // URL title
    private let urlTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    // URL
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
    
    override func binding() {
        super.binding()
        
        guard let detailViewModel = userDetailsViewModel else { return }
        
        detailViewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            guard let self = self else { return }
            // TODO: Show loading here
        }.store(in: &cancellables)
        
        detailViewModel.$user.receive(on: DispatchQueue.main).sink { [weak self] user in
            guard let self = self else { return }
            self.updateUserInfo(user)
        }.store(in: &cancellables)
    }
    
    private func setupView() {
        navigationItem.title = "User Details"
        /// Setup body
        
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
    
    private func updateUserInfo(_ user: User?) {
        if let user = user {
            infoContainer.isHidden = false
            userCardView.bind(user)
            followerView.setFollowNumber(count: user.followers)
            followingView.setFollowNumber(count: user.following)
            urlLabel.text = user.htmlUrl
        } else {
            infoContainer.isHidden = true
            // TODO: Show loading here
        }
    }
}
