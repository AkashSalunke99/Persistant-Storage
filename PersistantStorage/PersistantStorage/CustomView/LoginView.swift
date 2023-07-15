
import UIKit

class LoginView: UIView {
    let userName = {
        let label = UILabel(frame: CGRectMake(30, 100, 100, 60))
        label.text = "User Name"
        label.numberOfLines = 0
        return label
    }()
    
    let password = {
        let label = UILabel(frame: CGRectMake(30, 160, 100, 60))
        label.text = "Password"
        label.numberOfLines = 0
        return label
    }()
    
    let verifyPassword = {
        let label = UILabel(frame: CGRectMake(30, 220, 100, 60))
        label.text = "Verify Password"
        label.numberOfLines = 0
        return label
    }()
    
    let userNameTextField = {
        let textField = UITextField(frame: CGRectMake(150, 100, 200, 60))
        textField.placeholder = "Enter user name"
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    let passwordTextField = {
        let textField = UITextField(frame: CGRectMake(150, 160, 200, 60))
        textField.placeholder = "Enter password"
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    let verifyPasswordTextField = {
        let textField = UITextField(frame: CGRectMake(150, 220, 200, 60))
        textField.placeholder = "Verify entered password"
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    let signIn = {
        let button = UIButton(frame: CGRectMake(120, 230, 150, 50))
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let signUp = {
        let button = UIButton(frame: CGRectMake(120, 290, 150, 50))
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setUpUI()
        signIn.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.addSubview(userName)
        self.addSubview(userNameTextField)
        self.addSubview(password)
        self.addSubview(passwordTextField)
        self.addSubview(verifyPassword)
        self.addSubview(verifyPasswordTextField)
        self.addSubview(signIn)
        self.addSubview(signUp)
    }
    
    func showSignUpScreen() {
        signIn.isHidden = true
        signUp.isHidden = false
        verifyPassword.isHidden = false
        verifyPasswordTextField.isHidden = false
    }
    
    func showSignInScreen() {
        signUp.isHidden = true
        verifyPassword.isHidden = true
        verifyPasswordTextField.isHidden = true
        signIn.isHidden = false
    }
    
    @objc func signInButtonTapped(_ button: UIButton) {
        let rootViewController = getCoordinator()
        guard let userName = userNameTextField.text, !userName.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            rootViewController.displayPopup(title: "Enter text in blank section", message: "")
            return
        }
        let token = Authentication.authenticate(userName: userName, password: password)
        guard  !token.isEmpty else {
            return
        }
        rootViewController.showContactsScreen(for: token)
        resignTextFieldsAsFirstResponder()
    }
    
    @objc func signUpButtonTapped(_ button: UIButton) throws {
        let rootViewController = getCoordinator()
        guard let userName = userNameTextField.text, !userName.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let password1 = verifyPasswordTextField.text, !password1.isEmpty else {
            rootViewController.displayPopup(title: "Enter text in blank section", message: "")
            return
        }
        guard password == password1 else {
            rootViewController.displayPopup(title: "Password verification failed", message: "Please verify the entered password")
            return
        }
        let isSave = try Authentication.save(userName: userName, password: password)
        guard isSave else {
            return
        }
        
        let signUpVc = self.superview?.next as! SignUpVc
        signUpVc.tabBarController?.selectedIndex = 0
        rootViewController.displayPopup(title: "Successfully signed up", message: "Hurray!!")
        resignTextFieldsAsFirstResponder()
    }
    
    func resignTextFieldsAsFirstResponder() {
        userNameTextField.text = ""
        userNameTextField.resignFirstResponder()
        passwordTextField.text = ""
        passwordTextField.resignFirstResponder()
        verifyPasswordTextField.text = ""
        verifyPasswordTextField.resignFirstResponder()
    }
    
    func getCoordinator() -> Coordinator {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
           fatalError("Not able to get coordinator")
        }
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController.viewControllers.first as! Coordinator
    }
}
