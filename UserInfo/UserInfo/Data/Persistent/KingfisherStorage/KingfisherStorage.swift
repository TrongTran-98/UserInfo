//
//  KingfisherStorage.swift
//  UserInfo
//
//  Created by Trong/Corbin/서비스개발팀 on 1/23/25.
//

import Foundation
import UIKit
import Kingfisher

final class KingfisherStorage: ImageStorage {
    
    static let shared = KingfisherStorage()
    
    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func loadImage(in imageView: UIImageView, from path: String?,
                   placeholder: UIImage?, animated: Bool) {
        
        /// Get `URL`
        guard let path = path, let url = URL(string: path) else {
            imageView.image = placeholder
            return
        }
        
        var options: KingfisherOptionsInfo = [
            .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .targetCache(ImageCache.default),
            .fromMemoryCacheOrRefresh,
            .cacheMemoryOnly
        ]
        
        /// Add `fade animation`
        if animated { options.append(.transition(.fade(0.25))) }
        
        /// Create `resource`
        let resource = Kingfisher.ImageResource(downloadURL: url, cacheKey: path)
        
        /// Load Image
        imageView.kf.setImage(with: resource, placeholder: placeholder, options: options, completionHandler: nil)
    }
    
    func clearCache() {
        ImageCache.default.memoryStorage.removeAll()
    }
}
