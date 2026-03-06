//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by mong on 8/16/25.
//

import UIKit

enum DismissButtonType {
    
    case back
    case close
    
    var iconSystemName: String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
}

extension UIViewController {
    
    func setNavigationItem(with buttonType: DismissButtonType, target: Any?, action: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: buttonType.iconSystemName),
            style: .plain,
            target: target,
            action: action
        )
    }
}
