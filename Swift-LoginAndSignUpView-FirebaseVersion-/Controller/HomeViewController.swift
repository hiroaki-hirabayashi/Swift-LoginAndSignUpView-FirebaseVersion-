//
//  HomeViewController.swift
//  Swift-LoginAndSignUpView-FirebaseVersion-
//
//  Created by 平林 宏淳 on 2021/09/27.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    var user: User? {
        didSet{
            print("user.name", user?.name)
        }
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.layer.cornerRadius = 10
        
        if let user = user {
            nameLabel.text = user.name + "さんようこそ"
            emailLabel.text = user.email
            let dateString = dateFormatterForCreatedAt(date: user.createdAt.dateValue())
            dateLabel.text = "作成日: " + dateString
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confirmLoginUser()
    }
    
    private func confirmLoginUser() {
        // 初期でHomeに行く ログインしているかの判定処理が走る ログインしていなければSignUpViewに
        if Auth.auth().currentUser?.uid == nil || user == nil {
            segueToSingUpViewController()
        }
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        handleLogout()
    }
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            segueToSingUpViewController()
        } catch (let error) {
            print("ログアウトに失敗しました。\(error)")
        }
        
    }
    
    private func dateFormatterForCreatedAt(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    private func segueToSingUpViewController() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let SignUpViewController = storyboard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        let navigationController = UINavigationController(rootViewController: SignUpViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
        
        // instantiateInitialViewController使用時
        //                let storyboard = UIStoryboard(name: "Home", bundle: nil)
        //                let homeViewController = storyboard.instantiateInitialViewController()
        //                self.present(homeViewController!, animated: true, completion: nil)
    }
    
}
