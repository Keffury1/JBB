//
//  LoginViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 2/5/22.
//

import UIKit
import ProgressHUD
import KeychainSwift

class LoginViewController: UIViewController {

    // MARK: - Properties

    let keychain = KeychainSwift()

    // MARK: - Outlets

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    // MARK: - Methods
    
    private func setupSubviews() {
        loginView.layer.cornerRadius = 10
        loginButton.setTitle("", for: .normal)
        signUpView.layer.cornerRadius = 10
        signUpButton.setTitle("", for: .normal)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.text = keychain.get("Username")
        passwordTextField.text = keychain.get("Password")
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            return
        }

        ProgressHUD.show()

        Networking.shared.login(username: username, password: password) {
            DispatchQueue.main.async {
                self.keychain.set(username, forKey: "Username")
                self.keychain.set(password, forKey: "Password")
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        } onError: { errorMessage in
            ProgressHUD.showError()
            print(errorMessage!)
        }
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let url = URL(string: "https://thejbb.net/membership-account/membership-levels/")!
        UIApplication.shared.open(url)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != nil else { return false }
        textField.resignFirstResponder()
        return true
    }
}
