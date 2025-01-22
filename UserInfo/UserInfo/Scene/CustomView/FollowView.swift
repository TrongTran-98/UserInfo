//
//  FollowView.swift
//  UserInfo
//
//  Created by Corbin on 22/1/25.
//

import UIKit
import SnapKit
import Foundation

class FollowView: UIView {
    
    enum FollowType {
        case follower
        case following
        
        var title: String {
            switch self {
            case .follower:
                return "Follower"
            case .following:
                return "Following"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .follower:
                return UIImage(systemName: "person.2.circle")
            case .following:
                return UIImage(systemName: "bookmark.circle")
            }
        }
    }
    
    private let type: FollowType
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    init(type: FollowType, frame: CGRect = .zero) {
        self.type = type
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        let iconContainerView = UIView()
        iconContainerView.addSubview(iconView)
        iconView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.width.equalTo(30)
        })
        iconView.image = type.icon
        
        stackView.addArrangedSubview(iconContainerView)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(titleLabel)
        titleLabel.text = type.title
    }
    
    func setFollowNumber(count: Int?) {
        guard let count else { return }
        numberLabel.text = "\(count)"
    }
}
