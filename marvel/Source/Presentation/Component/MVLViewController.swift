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
    
    var targetCollectionView: UICollectionView? {
        return nil
    }
    
    private var configuration = UICollectionViewCompositionalLayoutConfiguration()
    
    private var dataSource: UICollectionViewDiffableDataSource<String, AnyHashable>!

    private(set) var sections = [any MVLSection]()
    
    var sectionSpacing: CGFloat {
        return 16
    }
    
    private var needReloadDataSource: Bool = true
    
    private var isRunningReload: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loading)
        
        loading.hidesWhenStopped = true
        loading.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        if let targetCollectionView {
            setup(targetCollectionView)
        }
    }

    func startLoading() {
        view.bringSubviewToFront(loading)
        loading.startAnimating()
    }
    
    func stopLoading() {
        loading.stopAnimating()
    }
    
    private func setup(_ collectionView: UICollectionView) {
        
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = sectionSpacing
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] index, environemnt in
                guard let self else { return nil }
                
                let section = self.sections[index]
                let sectionLayout = section.layout(environment: environemnt)
                return sectionLayout
            },
            configuration: configuration
        )
        
        dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self else { return UICollectionViewCell() }

            let section = self.sections[indexPath.section]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellReuseIdentifier, for: indexPath)

            if let cell = cell as? MVLCell {
                cell.configure(item: itemIdentifier)
            }

            return cell
        }
    }
    
    func applySection(_ section: any MVLSection) {
        
        sections.removeAll(where: { sc in
            sc.id == section.id
        })
        
        if section.items.isEmpty {
            // Handle empty case here
        }
        else {
            sections.append(section)
        }
        
        sections.sort { pre, cur in
            pre.priority.rawValue > cur.priority.rawValue
        }
        
        setNeedReloadDataSource()
    }
    
    private func setNeedReloadDataSource() {
        
        needReloadDataSource = true
        
        if !isRunningReload {
            reloadDataSource(animated: true)
        }
    }
    
    private func reloadDataSource(animated: Bool) {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, AnyHashable>()
        
        snapshot.appendSections(sections.map { $0.id })
        
        sections.forEach { section in
            snapshot.appendItems(
                section.items.map { AnyHashable($0) }, toSection: section.id
            )
        }
        
        isRunningReload = true
        
        needReloadDataSource = false
        
        dataSource.apply(snapshot, animatingDifferences: animated) { [weak self] in
            
            guard let self else { return }
            
            self.isRunningReload = false
            
            if self.needReloadDataSource == true {
                self.reloadDataSource(animated: true)
            }
        }
    }
}

extension MVLViewController: UICollectionViewDelegate {
    
}

extension Reactive where Base: MVLViewController {
    var loading: Binder<Bool> {
        Binder(base) { base, newValue in
            newValue ? base.startLoading() : base.stopLoading()
        }
    }
    
    var section: Binder<any MVLSection> {
        Binder(base) { base, newValue in
            base.applySection(newValue)
        }
    }
}