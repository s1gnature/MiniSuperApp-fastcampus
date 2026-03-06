//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by mong on 8/16/25.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    
    var topupBaseViewController: ViewControllable { get }
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>,
                            TopupInteractorDependency,
                            AddPaymentMethodDependency,
                            EnterAmountDependency,
                            CardOnFileDependency
{
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethodModel> { paymentMethodStream }
    var cardsOnFileRepository: CardOnFileRepository {
        dependency.cardsOnFileRepository
    }
    
    fileprivate var topupBaseViewController: ViewControllable {
        dependency.topupBaseViewController
    }
    
    let paymentMethodStream: CurrentValuePublisher<PaymentMethodModel>
    
    init(
        dependency: TopupDependency,
        paymentMethodStream: CurrentValuePublisher<PaymentMethodModel>
    ) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let patmentMethodStream = CurrentValuePublisher(
            PaymentMethodModel(
                id: "",
                name: "",
                digits: "",
                color: "",
                isPrimary: false
            )
        )
        let component = TopupComponent(dependency: dependency, paymentMethodStream: patmentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: addPaymentMethodBuilder,
            enterAmountBuildable: enterAmountBuilder,
            cardOnFileBuildable: cardOnFileBuilder
        )
    }
}
