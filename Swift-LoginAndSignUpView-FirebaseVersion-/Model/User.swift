//
//  User.swift
//  Swift-LoginAndSignUpView-FirebaseVersion-
//
//  Created by 平林 宏淳 on 2021/09/29.
//

import Foundation
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
