//
//  ViewController.swift
//  ToDoList-MVC
//
//  Created by Ardi Jorganxhi on 6.1.23.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class LoginViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.cornerRadius = 35.0
        view.addSubview(emailTextField)


        


}



    @IBAction func login(_ sender: Any) {



        UserService().login(mail: emailTextField.text!, password: passwordTextField.text!){result in
            switch result{
            case .success(_):
             
                print("Logged in succesfully!")
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
   
    }



}

