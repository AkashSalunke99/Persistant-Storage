import UIKit

class SignInVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginView = LoginView()
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.showSignInScreen()
        
        view.addSubview(loginView)
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

