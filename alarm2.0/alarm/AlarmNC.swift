//
//  AlarmNC.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/21.
//

import UIKit

class AlarmNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppear = UINavigationBar.appearance()
        navigationBarAppear.tintColor = UIColor.orange
        navigationBarAppear.barTintColor = UIColor.black
        navigationBarAppear.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
    }
    
}
