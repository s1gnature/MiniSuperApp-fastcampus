//
//  AdaptivePresentationControllerDelegateProxy.swift
//  MiniSuperApp
//
//  Created by mong on 8/9/25.
//

import Foundation
import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
    
    func presentationControllerDidDismiss()
}

final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    
    weak var delegate: AdaptivePresentationControllerDelegate?
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
