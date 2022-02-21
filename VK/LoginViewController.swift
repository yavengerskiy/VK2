//
//  ViewController.swift
//  VK
//
//  Created by Beelab on 03/01/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet var login: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didLoginButtonPressed() {
        if checkForValidationData() {
            
        }
    }
    
    
    
    private  func checkForValidationData() -> Bool {
        
        if login.text == "User", password.text ==  "123456" {
            // showAlert(title: "Congrats!", message: "All correct. To be continued ...")
            return true
        }
        showAlert(title: "Incorrect Login or Password 🥲", message: "Please try again with login: User \nand password: 123456 ")
        return false
    }
    
}

// MARK: - showAlert
extension LoginViewController {
    private func showAlert (title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
