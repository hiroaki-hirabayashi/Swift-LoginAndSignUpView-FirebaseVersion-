//
//  LoginViewController.swift
//  Swift-LoginAndSignUpView-FirebaseVersion-
//
//  Created by 平林 宏淳 on 2021/09/28.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        HUD.show(.progress, onView: view)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            if let error = error {
                print("ログイン情報の取得に失敗しました。\(error)")
                
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            
            // ログインしていれば取得できる
            guard let uid = response?.user.uid else { return }
            print("uid\(uid)")
            print("ログインに成功しました。")
            // コレクションは"uesrs" ドキュメントにuid  Dateにname、email、時間
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            userRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("ユーザー情報の取得に失敗しました。")
                    // インジケータ 失敗時
                    HUD.hide { (_) in
                        HUD.flash(.error, delay: 1)
                    }
                    return
                }
                
                guard let data = snapshot?.data() else { return }
                let user = User.init(dic: data)
                print("ユーザー情報の取得に成功しました。\(user.name)")
                self.segueToHomeViewController(user: user)
                HUD.hide { (_) in
                    HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                        self.segueToHomeViewController(user: user)
                    }
                }
            }
        }
    }
    
    private func segueToHomeViewController(user: User) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        homeViewController.user = user
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
        // instantiateInitialViewController使用時
        //                let storyboard = UIStoryboard(name: "Home", bundle: nil)
        //                let homeViewController = storyboard.instantiateInitialViewController()
        //                self.present(homeViewController!, animated: true, completion: nil)
    }
    
    @IBAction func tappedDontHaveAccountButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 144, blue: 0)
        }
        print("textField.text: ", textField.text)
    }
}
