//
//  User.swift
//  ToDoFirebase
//
//  Created by Владислав Соколов on 28.04.2022.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
