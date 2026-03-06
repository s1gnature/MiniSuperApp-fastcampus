//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by narr on 10/5/24.
//

import ModernRIBs
import Combine
import CombineExt

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {

    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?

    private let dependency: CardOnFileDashboardInteractorDependency
    private var cancellables = Set<AnyCancellable>()
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileDashboardInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        dependency.cardsOnFileRepository.cardOnFile
            .sink(receiveValue: { [weak self] cardOnfile in
                let viewModels = cardOnfile.prefix(4).map { PaymentMethodViewModel($0) }
                self?.presenter.update(with: viewModels)
            })
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapAddPaymentMethod() {
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}
