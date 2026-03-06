//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by narr on 5/6/24.
//

import ModernRIBs
import Combine
import CombineExt
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
    
    func superPayDashboardDidTapTopup()
}

protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?

    private let dependency: SuperPayDashboardInteractorDependency
    private var cancellables = Set<AnyCancellable>()
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: SuperPayDashboardPresentable,
        dependency: SuperPayDashboardInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

        dependency.balance
            .compactMap { [weak self] balance in
                self?.dependency.balanceFormatter.string(from: balance as NSNumber)
            }
            .sink(receiveValue: { [weak self] balanceString in
                self?.presenter.updateBalance(balanceString)
            })
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }

    // MARK: - PresentableListner

    func chargeBalance(amount: Double) {

    }
    
    func topupButtonDidTap() {
        listener?.superPayDashboardDidTapTopup()
    }
}
