//
//  UserCardView.swift
//  UserInfo
//
//  Created by Corbin on 22/1/25.
//

import UIKit
import SnapKit
import Foundation

class UserCardView: UIView {
    // Avatar
    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    // User name
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    // Seperator line
    private let seperatorLine: UIView = UIView()
    // Url label
    private let urlLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        avatarView.layer.cornerRadius = avatarView.frame.height/2
    }
    
    private func setupView() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.addSubview(avatarView)
        avatarView.snp.makeConstraints({ make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.height.equalTo(avatarView.snp.width)
        })
        
        let descStackView = UIStackView()
        descStackView.axis = .vertical
        descStackView.spacing = 10
        descStackView.alignment = .leading
        self.addSubview(descStackView)
        
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
