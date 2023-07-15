import UIKit

class Coordinator: UIViewController {
    
    let tabBarController1: UITabBarController = {
        let normalFont = UIFont.systemFont(ofSize: 20)
        let signInVc = SignInVc()
        let signInTabBar = UITabBarItem()
        signInTabBar.title = "Sign In"
        signInTabBar.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        signInVc.tabBarItem = signInTabBar
        
        let signUpVc = SignUpVc()
        let signUpTabBar = UITabBarItem()
        signUpTabBar.title = "Sign Up"
        signUpTabBar.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        signUpVc.tabBarItem = signUpTabBar
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.barTintColor = .clear
        tabBarController.viewControllers = [signInVc, signUpVc]
        tabBarController.selectedViewController = signInVc
        
        return tabBarController
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarController1.delegate = self
        self.addChild(tabBarController1)
        self.view.addSubview(tabBarController1.view)
        tabBarController1.didMove(toParent: self)
        tabBarController1.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Coordinator {
    
    func displayPopup(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension Coordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let loginView = viewController.view.subviews[0] as! LoginView
        let textField = loginView.userNameTextField
        let textField1 = loginView.passwordTextField
        let textField2 = loginView.verifyPasswordTextField
        textField.text = ""
        textField.resignFirstResponder()
        textField1.text = ""
        textField1.resignFirstResponder()
        textField2.text = ""
        textField2.resignFirstResponder()
    }
}

extension Coordinator {
    
    func showContactsScreen(for token: String) {
        let contactsVc = ContactsViewController(token: token)
        let navigationController = UINavigationController(rootViewController: contactsVc)
        navigationController.isNavigationBarHidden = false
        present(navigationController, animated: true, completion: nil)
    }
}

