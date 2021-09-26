//
//  ViewController.swift
//  Swift-LoginAndSignUpView-FirebaseVersion-
//
//  Created by 平林 宏淳 on 2021/09/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9294117647, green: 0.5921568627, blue: 0.3921568627, alpha: 1).cgColor, #colorLiteral(red: 0.8901960784, green: 0.1960784314, blue: 0.3098039216, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        return gradientLayer
    }()
    
    // textField backgroundColor R237 G241 B251
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
        registerButton.layer.cornerRadius = 10
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)

        registerButton.isEnabled = false
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let userNameIsEmpty = userNameTextField.text?.isEmpty ?? true
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
    
        if userNameIsEmpty || emailIsEmpty || passwordIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 144, blue: 0)
        }
        print("textField.text: ", textField.text)
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255 , blue: blue / 255, alpha: 1)
    }
}
