//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by mong on 8/16/25.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod()
    func detachAddPaymantMethod()
    func attachEnterAmount()
    func detachEnterAmoumt()
    func attachCardOnFile(paymentMethods: [PaymentMethodModel])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    
    func topupDidClose()
}

protocol TopupInteractorDependency {
    
    var cardsOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethodModel> { get }
}

final class TopupInteractor: Interactor,
                             TopupInteractable {
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let adaptivePresentationControllerDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    
    private var paymentMethods: [PaymentMethodModel] {
        self.dependency.cardsOnFileRepository.cardOnFile.value
    }
    
    private let dependency: TopupInteractorDependency

    init(
        dependency: TopupInteractorDependency
    ) {
        self.dependency = dependency
        super.init()
        adaptivePresentationControllerDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let card = dependency.cardsOnFileRepository.cardOnFile.value.first {
            // 금액 입력 화면
            dependency.paymentMethodStream.send(card)
            router?.attachEnterAmount()
        } else {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymantMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(model: PaymentMethodModel) {
        
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmoumt()
        listener?.topupDidClose()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
        print("@narr - attach add card")
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        router?.detachCardOnFile()
    }
}

extension TopupInteractor: AdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethods: paymentMethods)
    }
}
