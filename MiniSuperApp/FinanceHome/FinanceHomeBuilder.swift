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
    var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
    var balanceFormatter: BalanceFormatter

    // MARK: - CardOnFileDashboardDependency
    var cardsOnFileRepository: any CardOnFileRepository
    
    // MARK: - TopupDependency
    var topupBaseViewController: any ViewControllable

    private let balancePublisher: CurrentValuePublisher<Double>

    init(
        dependency: FinanceHomeDependency,
        balancePublisher: CurrentValuePublisher<Double>,
        balanceFormatter: BalanceFormatter,
        cardsOnFileRepository: CardOnFileRepository,
        topupBaseViewController: ViewControllable
    ) {
        self.balancePublisher = balancePublisher
        self.balanceFormatter = balanceFormatter
        self.cardsOnFileRepository = cardsOnFileRepository
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
        let balancePublisher = CurrentValuePublisher<Double>(10000)
        let balanceFomatter = BalanceFormatter()
        let cardOnFileRepository = CardOnFileRepositoryImpl()
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(
            dependency: dependency,
            balancePublisher: balancePublisher,
            balanceFormatter: balanceFomatter,
            cardsOnFileRepository: cardOnFileRepository,
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
