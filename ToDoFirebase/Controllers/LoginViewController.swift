//
//  ViewController.swift
//  ToDoFirebase
//
//  Created by Владислав Соколов on 14.04.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let segueId = "tasksSegue"
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var logintextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueId)!, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logintextField.text = ""
        passwordtextField.text = ""
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let scrollView = self.view as! UIScrollView
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.warningLabel.bounds.size.height)
    }

    func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let login = logintextField.text, let password = passwordtextField.text, login != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: login, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueId)!, sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    
    @IBAction func registrTapped(_ sender: Any) {
        guard let login = logintextField.text, let password = passwordtextField.text, login != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: login, password: password) { (user, error) in
            if error != nil {
                if user != nil {
                   
                } else {
                    print("user is not created")
                }
            } else {
                print(error!.localizedDescription)
            }

        }
    }
    
}

