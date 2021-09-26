//
//  ViewController.swift
//  Swift-LoginAndSignUpView-FirebaseVersion-
//
//  Created by 平林 宏淳 on 2021/09/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.8901960784, green: 0.1960784314, blue: 0.3098039216, alpha: 1).cgColor, #colorLiteral(red: 0.9294117647, green: 0.5921568627, blue: 0.3921568627, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 0.6]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        registerButton.layer.cornerRadius = 10
    }
    
   
    
}

// textField backgroundColor R237 G241 B251
