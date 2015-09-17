//
//  User.swift
//  PlusOnePart2
//
//  Created by Elex Lee on 9/14/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String
    var mainUser: Bool
   
    init(username: String, mainUser: Bool) {
        self.username = username
        self.mainUser = mainUser
    }
}
