//
//  Label_ViewController.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/13.
//

import UIKit

class LabelViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelTextField: UITextField!
    
    var alarmLabel:String = ""
    var delegate:LabelToAdd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        navigationItem.title = "標籤"
        editTextField()
        labelTextField.delegate = self
        //textField 進場動畫
        UIView.animate(withDuration: 0.3) {
            self.labelTextField.frame = CGRect(x: 0, y: 355, width: 414, height: 34)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //textField 退場動畫
        UIView.animate(withDuration: 0.2) {
            self.labelTextField.frame = CGRect(x: 400, y: 500, width: 414, height: 34)
        }
        editLabel()
    }
    
    //MARK: reture鍵 返回
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: true)
        return true
    }
    
    func editTextField() {
        labelTextField.returnKeyType = .done
        labelTextField.clearButtonMode = .whileEditing
        labelTextField.text = alarmLabel
        labelTextField.becomeFirstResponder()
        labelTextField.enablesReturnKeyAutomatically = true
    }
    
    func editLabel() {
        if let label = labelTextField.text {
            if label == "" {
                delegate.labelToAdd(label: "鬧鐘")
            }else{
                delegate.labelToAdd(label: label)
            }
        }
    }
    
}
