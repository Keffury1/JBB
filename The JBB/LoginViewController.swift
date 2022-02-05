//
//  LoginViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 2/5/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Outlets

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
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
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != nil else { return false }
        textField.resignFirstResponder()
        return true
    }
}