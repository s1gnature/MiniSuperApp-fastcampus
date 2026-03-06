import Foundation
import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>,
                                  SuperPayDashboardDependency,
                                  CardOnFileDashboardDependency,
                                  AddPaymentMethodDependency,
                                  TopupDependency {

    // MARK: - SuperPayDashboardDependency
    let superPayRepository: SuperPayRepository
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var balanceFormatter: BalanceFormatter

    // MARK: - CardOnFileDashboardDependency
    var cardsOnFileRepository: any CardOnFileRepository
    
    // MARK: - TopupDependency
    var topupBaseViewController: any ViewControllable

    init(
        dependency: FinanceHomeDependency,
        balanceFormatter: BalanceFormatter,
        cardsOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository,
        topupBaseViewController: ViewControllable
    ) {
        self.balanceFormatter = balanceFormatter
        self.cardsOnFileRepository = cardsOnFileRepository
        self.superPayRepository = superPayRepository
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {

    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        let balanceFomatter = BalanceFormatter()
        let superPayRepository = SuperPayRepositoryImpl()
        let cardOnFileRepository = CardOnFileRepositoryImpl()
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(
            dependency: dependency,
            balanceFormatter: balanceFomatter,
            cardsOnFileRepository: cardOnFileRepository,
            superPayRepository: superPayRepository,
            topupBaseViewController: viewController
        )
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener

        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymetMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let topupBuilder = TopupBuilder(dependency: component)

        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: addPaymetMethodBuilder,
            topupBuildable: topupBuilder
        )
    }
}
