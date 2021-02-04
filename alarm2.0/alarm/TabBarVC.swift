//
//  TabBarVC.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/20.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.orange
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
