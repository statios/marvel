//
//  ViewController.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import UIKit
import RxSwift

class MVLViewController: UIViewController {
    
    lazy var disposeBag = DisposeBag()
    
    private let loading = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loading)
        
        loading.hidesWhenStopped = true
        loading.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func startLoading() {
        view.bringSubviewToFront(loading)
        loading.startAnimating()
    }
    
    func stopLoading() {
        loading.stopAnimating()
    }

}

extension Reactive where Base: MVLViewController {
    var loading: Binder<Bool> {
        Binder(base) { base, newValue in
            newValue ? base.startLoading() : base.stopLoading()
        }
    }
}
