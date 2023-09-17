//
//  MVLSection.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import UIKit

protocol MVLSection: Hashable {
    
    associatedtype Item: Hashable
    associatedtype Cell: MVLCell
    
    var id: String { get }
    
    var items: [Item] { get }
    
    var priority: MVLSectionPriority { get }
    
    var spacing: CGFloat { get }
    
    var inset: NSDirectionalEdgeInsets { get }
    
    var itemSize: NSCollectionLayoutSize { get }
    
    var groupSize: NSCollectionLayoutSize { get }
    
    var groupInset: NSDirectionalEdgeInsets? { get }
    
    var groupSpacing: NSCollectionLayoutSpacing? { get }
    
    var groupCount: Int? { get }
    
    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior { get }
}

// MARK: - Default Implementations

extension MVLSection {
    
    static var defaultID: String {
        return String(describing: Self.self)
    }
    
    var id: String {
        return Self.defaultID
    }
    
    var priority: MVLSectionPriority {
        return .required
    }
    
    var itemSize: NSCollectionLayoutSize {
        return NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(156)
        )
    }
    
    var groupSize: NSCollectionLayoutSize {
        return itemSize
    }
    
    var groupInset: NSDirectionalEdgeInsets? {
        return nil
    }
    
    var groupSpacing: NSCollectionLayoutSpacing? {
        return nil
    }

    var groupCount: Int? {
        return nil
    }
    
    var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        return .none
    }
    
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group: NSCollectionLayoutGroup

        if let groupCount {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: groupCount)
        }
        else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }

        if let groupSpacing {
            group.interItemSpacing = groupSpacing
        }
        
        if let groupInset {
            group.contentInsets = groupInset
        }
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        section.interGroupSpacing = spacing
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        
        return section
    }
    
    var cellReuseIdentifier: String {
        return String(describing: Cell.self)
    }
}

struct MVLSectionPriority: Equatable, RawRepresentable {

    private static var minimum: Float {
        return .zero
    }

    private static var maximum: Float {
        return 1_000
    }

    var rawValue: Float

    init(rawValue: Float) {
        var value = rawValue
        value = max(value, MVLSectionPriority.minimum)
        value = min(value, MVLSectionPriority.maximum)
        self.rawValue = value
    }

    static var required: Self {
        return Self.init(rawValue: 1_000)
    }

    static var defaultHigh: Self {
        return Self.init(rawValue: 750)
    }

    static var defaultLow: Self {
        return Self.init(rawValue: 250)
    }

}
