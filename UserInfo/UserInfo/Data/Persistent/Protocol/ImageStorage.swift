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
    func loadImage(in imageView: UIImageView, from path: String?, placeholder: UIImage?, animated: Bool)
    func clearCache()
}
