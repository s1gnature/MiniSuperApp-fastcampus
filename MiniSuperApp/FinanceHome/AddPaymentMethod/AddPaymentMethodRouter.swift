//
//  AddPaymentMethodRouter.swift
//  MiniSuperApp
//
//  Created by mong on 8/9/25.
//

import ModernRIBs

protocol AddPaymentMethodInteractable: Interactable {
    var router: AddPaymentMethodRouting? { get set }
    var listener: AddPaymentMethodListener? { get set }
    
    var adaptivePresentationControllerDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol AddPaymentMethodViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AddPaymentMethodRouter: ViewableRouter<AddPaymentMethodInteractable, AddPaymentMethodViewControllable>, AddPaymentMethodRouting {
    
    let adaptivePresentationControllerDelegateProxy: AdaptivePresentationControllerDelegateProxy

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AddPaymentMethodInteractable, viewController: AddPaymentMethodViewControllable) {
        self.adaptivePresentationControllerDelegateProxy = interactor.adaptivePresentationControllerDelegateProxy
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
