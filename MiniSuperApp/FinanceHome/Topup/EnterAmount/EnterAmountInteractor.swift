//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by mong on 8/16/25.
//

import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
}

protocol EnterAmountListener: AnyObject {
    
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
}

protocol EnterAmountInteractorDependency {
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethodModel> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>,
                                   EnterAmountInteractable,
                                   EnterAmountPresentableListener {

    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?

    private let dependency: EnterAmountInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: EnterAmountPresentable,
        dependency: EnterAmountInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency
            .selectedPaymentMethod
            .sink { [weak self] paymentMethodModel in
                self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethodModel))
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        
    }
}
