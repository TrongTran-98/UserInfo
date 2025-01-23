//
//  UIImageView+Extension.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/23/25.
//

import UIKit
import Foundation

extension UIImageView {
    
    func loadImage(from path: String?,
                   placeholder: UIImage? = UIImage(systemName: "person"),
                   animated: Bool = true,
                   storage: ImageStorage = KingfisherStorage.shared) {
        
        storage.loadImage(in: self, from: path, placeholder: placeholder, animated: animated)
    }
}
