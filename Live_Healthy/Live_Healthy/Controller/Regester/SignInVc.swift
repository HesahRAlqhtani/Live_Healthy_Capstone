//
//  SignInVc.swift
//  Live_Healthy
//
//  Created by Hesah Alqhtani on 07/12/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignInVc: UIViewController {
    
    
    
    @IBOutlet weak var emaill: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(getter: UIView.overrideUserInterfaceStyle))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserInfo()
    }
    
    @IBAction func sginInButton(_ sender: UIButton) {
        validateFileds()
    }
    @IBAction func createNewAccount(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    @IBAction func changePasswordVisibility(_ sender: UIButton) {
        password.isSecureTextEntry.toggle()
        if password.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.slash.fill") {
                sender.setImage(image, for: .normal)
            }
        }
    }
    //    use func for ensure pass and email
    func validateFileds(){
        // use if statment
        if emaill.text?.isEmpty == true{
            print("No userNameText".loclaized)
            return
        }
        if password.text?.isEmpty == true{
            print("No Password Text".loclaized)
            return
        }
        login()
    }
    func login(){
        Auth.auth().signIn(withEmail: emaill.text!, password: password.text!) { [weak self]authResult, err in
            
            if err != nil {
                
                let alert = UIAlertController(title: "Error".loclaized, message:"Sorry , we could not find your account.".loclaized , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".loclaized , style: .default , handler: nil))
                self?.present(alert, animated : true)
            }else {
                self?.performSegue(withIdentifier: "toHome", sender: nil)
                
            }
            self!.checkUserInfo()
        }
        
    }
    
    
    func checkUserInfo(){
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser?.uid)
            performSegue(withIdentifier: "toHome", sender: nil)
            
        }
        
    }
    
    
    
}
