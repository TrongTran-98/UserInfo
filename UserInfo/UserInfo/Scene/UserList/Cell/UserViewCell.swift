//
//  UserViewCell.swift
//  UserInfo
//
//

import UIKit
import SnapKit
import Foundation

class UserViewCell: UITableViewCell {
    
    private let cardView = UserCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        })
    }
    
    // MARK: - Bind Data
    func bind(_ user: User) {
        cardView.bind(user)
    }
    
}
