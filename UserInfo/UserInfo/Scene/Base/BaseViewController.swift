//
//  BaseViewController.swift
//  UserInfo
//
//

import Foundation
import Combine
import SnapKit
import UIKit

class BaseViewController: UIViewController {
    
    let viewModel: BaseViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    private lazy var loadingIndicator = UIActivityIndicatorView()
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    func binding() {
        viewModel.errorPublisher.sink { [weak self] error in
            // handle error here
            guard let self = self else { return }
            self.handleError(error: error)
        }.store(in: &cancellables)
    }
    
    func handleError(error: Error) {
        /// Defined URL Session errors
        if let urlError = error as? URLSessionError {
            /// Other error cases
        } else {
            /// Other error cases
        }
    }
    
    func showLoadingIndicatorView() {
        if loadingIndicator.superview == nil {
            view.addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints({ make in
                make.center.equalToSuperview()
                make.width.height.equalToSuperview()
            })
        }
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicatorView() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
