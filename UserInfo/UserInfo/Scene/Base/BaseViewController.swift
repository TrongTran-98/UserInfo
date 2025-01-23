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
    
    private lazy var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
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
    
    // MARK: - Binding
    func binding() {
        viewModel.errorPublisher.receive(on: DispatchQueue.main).sink { [weak self] error in
            // handle error here
            guard let self = self else { return }
            self.handleError(error: error)
        }.store(in: &cancellables)
    }
    
    // MARK: - Error Handling
    func handleError(error: Error) {
        /// Defined URL Session errors
        if let urlError = error as? URLSessionError {
            /// Other error cases
            showErrorMessage(urlError.description)
        } else {
            /// Other error cases
            showErrorMessage(error.localizedDescription)
        }
    }
    
    // MARK: - Actions
    func showErrorMessage(_ message: String) {
        let errorAlert = UIAlertController()
        errorAlert.title = "Error occurs"
        errorAlert.message = message
        let action = UIAlertAction(title: "Ok", style: .default)
        errorAlert.addAction(action)
        self.present(errorAlert, animated: true)
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
