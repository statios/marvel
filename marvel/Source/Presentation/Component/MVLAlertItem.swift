//
//  MVLAlertItem.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import UIKit
import RxSwift

typealias MVLAlertStyle = UIAlertController.Style
typealias MVLAlertAction = UIAlertAction

struct MVLAlertItem {
    var title: String?
    var message: String?
    var style: MVLAlertStyle
    var confirmTitle: String?
    var cancelTitle: String?
    
    static func plain(_ message: String) -> MVLAlertItem {
        return MVLAlertItem(
            message: message,
            style: .alert,
            confirmTitle: "Confirm"
        )
    }
}

final class MVLAlertController: UIAlertController {
    
    convenience init(_ item: MVLAlertItem) {
        self.init(title: item.title, message: item.message, preferredStyle: item.style)
    }
}

extension MVLViewController {
    
    func displayAlert(_ item: MVLAlertItem, completion: ((MVLAlertAction) -> Void)? = nil) {
        
        let alert = MVLAlertController(item)
        
        if let cancelTitle = item.cancelTitle {
            let cancel = MVLAlertAction(title: cancelTitle, style: .cancel)
            alert.addAction(cancel)
        }
        
        if let confirmTitle = item.confirmTitle {
            let confirm = MVLAlertAction(title: confirmTitle, style: .default) { [weak alert] action in
                alert?.dismiss(animated: true, completion: {
                    completion?(action)
                })
            }
            alert.addAction(confirm)
        }
        
        present(alert, animated: true)
    }
}

extension Reactive where Base: MVLViewController {
    var alert: Binder<MVLAlertItem> {
        Binder(base) { base, newValue in
            base.displayAlert(newValue)
        }
    }
}
