//
//  AuthViewController.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 14.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AppDelegate.shared().authService
    }
    
    @IBAction func signUp(_ sender: Any) {
        authService.wakeUpSession()
    }

}
