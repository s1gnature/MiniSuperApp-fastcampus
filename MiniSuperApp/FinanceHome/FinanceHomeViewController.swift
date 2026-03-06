import ModernRIBs
import UIKit

protocol FinanceHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FinanceHomeViewController: UIViewController, FinanceHomePresentable, FinanceHomeViewControllable {

    // MARK: - Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()

    weak var listener: FinanceHomePresentableListener?

    init() {
        super.init(nibName: nil, bundle: nil)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        title = "슈퍼페이"
        tabBarItem = UITabBarItem(title: "슈퍼페이", image: UIImage(systemName: "creditcard"), selectedImage: UIImage(systemName: "creditcard.fill"))

        // MARK: - Hierarchy

        [
            stackView
        ].forEach { view.addSubview($0) }

        // MARK: - Constraints

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    // MARK: - FinanceHomeViewControllable

    func addDashboard(_ viewControllable: ViewControllable) {
        let viewController = viewControllable.uiviewController
        addChild(viewController)
        stackView.addArrangedSubview(viewController.view)
//        NSLayoutConstraint.activate([
//            viewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            viewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
//            viewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
//        ])
        viewController.didMove(toParent: self)
    }
}
