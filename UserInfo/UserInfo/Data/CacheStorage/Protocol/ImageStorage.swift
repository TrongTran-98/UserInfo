//
//  ImageStorage.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/23/25.
//

import Foundation
import UIKit
import Kingfisher

protocol ImageStorage {
    
    /// Load Image from URL
    /// - Parameters:
    ///   - imageView: ImageView to load image
    ///   - path: URL path
    ///   - placeholder: placeholder image
    ///   - animated: animated option
    func loadImage(in imageView: UIImageView, from path: String?, placeholder: UIImage?, animated: Bool)
    
    /// Clear all cached datas
    func clearCache()
}
