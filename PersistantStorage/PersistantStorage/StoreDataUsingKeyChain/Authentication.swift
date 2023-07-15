import UIKit
import CryptoKit

struct AuthInfo: Codable {
    let token: String
}

class Authentication {
    
    private static let usersKey = "Users"
    
    private static func makeKey(username: String, password: String) -> String {
        let salt = "ixs^X9T@12QQvu1W"
        return "\(username).\(password).\(salt)".sha256()
    }
    
    static func save(userName: String, password: String) throws -> Bool {
        let rootViewController = getCoordinator()
        var users: [String] = []
        if let usersData = KeychainWrapper.standard.data(forKey: Self.usersKey) {
            let decodeUsers = try! JSONDecoder().decode([String].self, from: usersData)
            users.append(contentsOf: decodeUsers)
        }
        guard !users.contains(userName) else {
            rootViewController.displayPopup(title: "User name is already taken", message: "Please enter valid user name")
            return false
        }
        let auth = AuthInfo(token: UUID().uuidString)
        let data = try! JSONEncoder().encode(auth)
        let key = makeKey(username: userName, password: password)
        guard KeychainWrapper.standard.set(data, forKey: key) else {
            fatalError("Not able to set data for password key in key chain")
        }
        users.append(userName)
        KeychainWrapper.standard.set(try! JSONEncoder().encode(users), forKey: Self.usersKey)
        return true
    }
    
    static func authenticate(userName: String, password: String) -> String {
        let rootViewController = getCoordinator()
        guard let usersData = KeychainWrapper.standard.data(forKey: Self.usersKey),
              let users = try? JSONDecoder().decode([String].self, from: usersData),
              users.contains(userName) else {
            rootViewController.displayPopup(title: "Invalid User Name", message: "Please enter valid user name")
            return ""
        }
        let key = makeKey(username: userName, password: password)
        guard let data = KeychainWrapper.standard.data(forKey: key) else {
            rootViewController.displayPopup(title: "Invalid password", message: "Please enter valid password ")
            return ""
        }
        let authInfo = try! JSONDecoder().decode(AuthInfo.self, from: data)
        print("Successfully Authenticated")
        return authInfo.token
    }
    
    static func getCoordinator() -> Coordinator {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            fatalError("Not able to get coordinator")
        }
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController.viewControllers.first as! Coordinator
    }
}

extension String {
    fileprivate func sha256() -> String {
        return SHA256.hash(data: Data(self.utf8)).description
    }
}
