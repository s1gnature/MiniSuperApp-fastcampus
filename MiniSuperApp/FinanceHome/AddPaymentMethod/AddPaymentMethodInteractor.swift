//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by mong on 8/9/25.
//

import ModernRIBs
import Combine

protocol AddPaymentMethodRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    var adaptivePresentationControllerDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol AddPaymentMethodPresentable: Presentable {
    var listener: AddPaymentMethodPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddPaymentMethodListener: AnyObject {
    
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(model: PaymentMethodModel)
}

protocol AddPaymentMethodInteractorDependency {
    
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {

    weak var router: AddPaymentMethodRouting?
    weak var listener: AddPaymentMethodListener?
    
    let adaptivePresentationControllerDelegateProxy = AdaptivePresentationControllerDelegateProxy()

    private let dependency: CardOnFileDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(
        presenter: AddPaymentMethodPresentable,
        dependency: CardOnFileDashboardInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
        adaptivePresentationControllerDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.addPaymentMethodDidTapClose()
    }
    
    func didTapConfirm(number: String, cvc: String, expiry: String) {
        dependency.cardsOnFileRepository.addCard(info: .init(
            number: number,
            cvc: cvc,
            expiration: expiry
        ))
        .sink(
            receiveCompletion: { _ in
                
            },
            receiveValue: { [weak self] model in
                self?.listener?.addPaymentMethodDidAddCard(model: model)
            }
        )
        .store(in: &cancellables)
    }
}

extension AddPaymentMethodInteractor: AdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss() {
        listener?.addPaymentMethodDidTapClose()
    }
}
