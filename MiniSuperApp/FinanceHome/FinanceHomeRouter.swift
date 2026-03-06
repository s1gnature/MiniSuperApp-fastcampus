import ModernRIBs

protocol FinanceHomeInteractable: Interactable,
                                  SuperPayDashboardListener,
                                  CardOnFileDashboardListener,
                                  AddPaymentMethodListener,
                                  TopupListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ viewControllable: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {

    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    private var cardOnFileDashboardRouting: Routing?
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    private let topupBuildable: TopupBuildable
    private var topupRouing: Routing?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        topupBuildable: TopupBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.topupBuildable = topupBuildable
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }

    func attachSuperPayDashboard() {
        if superPayRouting != nil { return }

        let router = superPayDashboardBuildable.build(withListener: interactor)
        let viewControllable = router.viewControllable
        self.viewController.addDashboard(viewControllable)

        self.superPayRouting = router
        attachChild(router)
    }

    func attachCardOnFileDashboard() {
        if cardOnFileDashboardRouting != nil { return }

        let router = cardOnFileDashboardBuildable.build(withListener: interactor)
        let viewControllable = router.viewControllable
        self.viewController.addDashboard(viewControllable)

        self.cardOnFileDashboardRouting = router
        attachChild(router)
    }
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil { return }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor)
        
        let navigationController = NavigationControllerable(root: router.viewControllable)
        
        navigationController.navigationController.presentationController?.delegate = router.adaptivePresentationControllerDelegateProxy
        self.viewControllable.present(navigationController, animated: true, completion: nil)
        
        self.addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = self.addPaymentMethodRouting else { return }
        viewControllable.dismiss(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil 
    }
    
    func attachTopup() {
        if topupRouing != nil { return }
        let router = topupBuildable.build(withListener: interactor)
        topupRouing = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = self.topupRouing else { return }
        detachChild(router)
        topupRouing = nil
    }
}
