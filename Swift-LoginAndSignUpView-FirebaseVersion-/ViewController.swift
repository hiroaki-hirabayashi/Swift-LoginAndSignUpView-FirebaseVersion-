//
//  ViewController.swift
//  Swift-LoginAndSignUpView-FirebaseVersion-
//
//  Created by 平林 宏淳 on 2021/09/25.
//

import UIKit
import Firebase

struct User {
    let name: String
    let email: String
    let createdAt: Timestamp
    
    init(dic: [String: Any]) {
        name = dic["name"] as! String
        email = dic["email"] as! String
        createdAt = dic["createdAt"] as! Timestamp
    }
}

final class ViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    // textField backgroundColor R210(237) G241 B251
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradientLayer()

        registerButton.isEnabled = false
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // キーボード出現時の通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボード無くなる時の通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9294117647, green: 0.5921568627, blue: 0.3921568627, alpha: 1).cgColor, #colorLiteral(red: 0.8901960784, green: 0.1960784314, blue: 0.3098039216, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
        registerButton.layer.cornerRadius = 10
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
    }
    
    @objc private func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        // キーボード出現時にViewを持ち上げてテキストフィールドが隠れないようにする
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let registarButtonMaxY = registerButton.frame.maxY
        let distance = registarButtonMaxY - keyboardMinY + 20
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [],  animations: {
            self.view.transform = transform
        })
        
    }
    
    @objc private func hideKeyboard() {
        // キーボードが隠れた時に元の位置に戻す
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [],  animations: {
            self.view.transform = .identity
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction private func tappedRegistarButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    
    private func handleAuthToFirebase() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            if let error = error {
                print("認証情報の保存に失敗しました。\(error)")
                return
            }
        }
        addUserInfoToFirestore(email: email)
        
    }
    
    private func addUserInfoToFirestore(email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.userNameTextField.text else { return }
        
        let docDate = [ "name": name, "email": email, "createdAt": Timestamp()] as [String : Any]
        // コレクションは"uesrs" ドキュメントにuid  Dateにname、email、時間
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docDate) { (error) in
            if let error = error {
                print("Firestoreへの認証に失敗しました。\(error)")
                return
            }
            print("Firestoreへの保存に成功しました。")
            
            userRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("ユーザー情報の取得に失敗しました。")
                    return
                }
                guard let date = snapshot?.data() else { return }
                let user = User.init(dic: date)
                print("ユーザー情報の取得に成功しました。\(user.name)")
//                
//                let storyboard = UIStoryboard(name: "Home", bundle: nil)
//                let homeViewController = storyboard.instantiateInitialViewController()
//                self.present(homeViewController!, animated: true, completion: nil)
                
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
            }
        }
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
