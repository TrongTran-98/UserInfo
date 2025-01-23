//
//  KingfisherStorageTests.swift
//  UserInfo
//

@testable import UserInfo
import XCTest
import UIKit
import Kingfisher

class KingfisherStorageTests: XCTestCase {
    var storage: KingfisherStorage!
    var imageView: UIImageView!
    
    override func setUp() {
        super.setUp()
        storage = KingfisherStorage.shared
        imageView = UIImageView()
        storage.clearCache()
    }
    
    override func tearDown() {
        storage.clearCache()
        storage = nil
        imageView = nil
        super.tearDown()
    }
    
    func testLoadImageWithValidURL() {
        let expectation = XCTestExpectation(description: "Load image from a valid URL")
        let validURL = "https://avatars.githubusercontent.com/u/101?v=4"
        
        // Load image with valid url
        storage.loadImage(
            in: imageView,
            from: validURL,
            placeholder: nil,
            animated: false
        )
        
        // Verify image is loaded by valid url
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.imageView.image, "ImageView should have an image loaded from the URL.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadImageWithInvalidURLUsePlaceholder() {
        let expectation = XCTestExpectation(description: "Load image from a valid URL")
        let placeholder = UIImage(systemName: "person")!
        let invalidURL = "invalid url"
        
        // Load image with invalid url
        storage.loadImage(
            in: imageView,
            from: invalidURL,
            placeholder: placeholder,
            animated: false
        )
        
        // Verify image is assigned by placeholder
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.imageView.image, "ImageView should have an image loaded from the placeholder.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testClearCache() {
        let key = "test_key"
        let testImage = UIImage(systemName: "person")!
        
        ImageCache.default.store(testImage, forKey: key)
        
        // Verify image is stored in cache
        let cachedImage = ImageCache.default.retrieveImageInMemoryCache(forKey: key)
        XCTAssertNotNil(cachedImage, "Image should exist in the cache before clearing.")
        
        // Clear the cache
        self.storage.clearCache()
        
        // Verify cache is empty
        let clearedImage = ImageCache.default.retrieveImageInMemoryCache(forKey: key)
        XCTAssertNil(clearedImage, "Cache should be empty after clearing.")
    }
}
