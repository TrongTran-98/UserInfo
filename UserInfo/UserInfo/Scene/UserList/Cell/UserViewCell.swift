//
//  UserViewCell.swift
//  UserInfo
//
//

import UIKit
import SnapKit
import Foundation

class UserViewCell: UITableViewCell {
    
    private let containerView = UIView()
    
    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let seperatorLine: UIView = UIView()
    
    private let urlLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        avatarView.layer.cornerRadius = avatarView.frame.height/2
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        })
        
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.addSubview(avatarView)
        avatarView.snp.makeConstraints({ make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.height.equalTo(avatarView.snp.width)
        })
        
        let descStackView = UIStackView()
        descStackView.axis = .vertical
        descStackView.spacing = 10
        descStackView.alignment = .leading
        containerView.addSubview(descStackView)
        
        descStackView.addArrangedSubview(usernameLabel)
        descStackView.addArrangedSubview(seperatorLine)
        descStackView.addArrangedSubview(urlLabel)
        
        seperatorLine.backgroundColor = .separator
        seperatorLine.snp.makeConstraints({ make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        })
        
        descStackView.snp.makeConstraints({ make in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().inset(10)
        })
    }
    
    // MARK: - Bind Data
    func bind(_ user: User) {
        /// Load image
        self.usernameLabel.text = user.login
        /// Link
        let linkAttribute = htmlStyleAttributeText(text: user.htmlUrl)
        self.urlLabel.attributedText = linkAttribute
    }
    
    private func htmlStyleAttributeText(text: String?) -> NSAttributedString? {
        guard let text else { return nil }
        let link = URL(string: text)!
        let attributes: [NSAttributedString.Key: Any] = [.link: link,
                                                         .font: UIFont.systemFont(ofSize: 12)]
        
        let wholeRange = NSRange(text.startIndex..., in: text)
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(attributes, range: wholeRange)
        
        return attributedString
    }
    
}
