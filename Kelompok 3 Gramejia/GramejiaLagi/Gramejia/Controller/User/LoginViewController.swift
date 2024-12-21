//
//  LoginViewController.swift
//  Gramejia
//
//  Created by fits on 13/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    var createUserData = CreateUserData()
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    var showPassword = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menambahkan gesture recognizer untuk menutup keyboard saat tap di luar
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false // Ini memastikan gesture recognizer tidak memblokir interaksi lainnya
                view.addGestureRecognizer(tapGesture)
        
        print(UserDefaults.standard.bool(forKey: "isLogin"))
        print(UserDefaults.standard.string(forKey: "usernameLogin") ?? "unknown")
        
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "isLogin") {
                print("User is logged in")
                self.performSegue(withIdentifier: "gotohome", sender: self)
            }
        }

        
        let usernameImage = UIImage(named:"PersonIcon")
        addTextFieldIconUsername(txtField: Username, andImage: usernameImage!)
        
        let passwordImage = UIImage(named:"PasswordIcon")
        addTextFieldIconPassword(txtField: Password, andImage: passwordImage!)
        
        let UsernamePlaceholder = "Username"
        let PasswordPlaceholder = "Password"
        
        let UsernameAttributes : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
            
        Username.attributedPlaceholder = NSAttributedString(string: UsernamePlaceholder , attributes: UsernameAttributes)
        
        let PasswordAttributes : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        
        Password.attributedPlaceholder = NSAttributedString(string: PasswordPlaceholder , attributes: PasswordAttributes)
        
        addShowHidePassowrd(to: Password)
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true) // Menutup keyboard
       }
    
    func addTextFieldIconUsername(txtField: UITextField, andImage img: UIImage) {
        let leftIconView = UIImageView(image: img)

 
        let iconWidth: CGFloat = 28
        let iconHeight: CGFloat = 36
        
        leftIconView.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight)

       
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: iconWidth + 20, height: iconHeight))
        
 
        leftIconView.center = paddingView.center
        paddingView.addSubview(leftIconView)
        txtField.leftView = paddingView
        txtField.leftViewMode = .always
    }
    
    func addTextFieldIconPassword(txtField: UITextField, andImage img: UIImage) {
        let leftIconView = UIImageView(image: img)

 
        let iconWidth: CGFloat = 28
        let iconHeight: CGFloat = 30
        
        leftIconView.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight)

       
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: iconWidth + 20, height: iconHeight))
        
 
        leftIconView.center = paddingView.center
        paddingView.addSubview(leftIconView)
        txtField.leftView = paddingView
        txtField.leftViewMode = .always
    }
   
    func addShowHidePassowrd (to textField: UITextField){
        let showHideButton = UIButton(type: .custom)
        showHideButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        showHideButton.setImage(UIImage(named: "close"), for: .normal)
        
        showHideButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        showHideButton.center = paddingView.center
        paddingView.addSubview(showHideButton)
        
        textField.rightView = paddingView
        textField.rightViewMode = .always
    }
    
    @objc func togglePasswordVisibility (_ sender: UIButton){
        if sender.superview?.superview == Password {
            showPassword.toggle()
            Password.isSecureTextEntry = showPassword
            let image = showPassword ? UIImage(named: "close") : UIImage(named: "open")
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func loginBTN(_ sender: Any) {
        let user = Username.text
        let pass = Password.text
        if user?.isEmpty == true && pass?.isEmpty == true{
            showAlertfield(message: "Please insert all field")
        }else{
            if createUserData.checkIfUsernameExists(username: user!){
                if createUserData.checkPasswordForUsername(username: user!, password: pass!){
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.set(user, forKey: "usernameLogin")
                    performSegue(withIdentifier: "gotohome", sender: self)
                    
                }else{
                    showAlertWithHandler(message: "Your password doesn’t exist in our system")
                }
            }else{
                showAlertCreateAccount(message: "Username doesn’t exist, create account")
            }
        }
        
    }
    
    func showAlertfield(message: String) {
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(cancelAction)
        
        // Menampilkan alert
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithHandler(message: String) {
            let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
            
            // Tombol Cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                print("User cancelled the action.")
            })
            alert.addAction(cancelAction)
            
            // Menampilkan alert
            present(alert, animated: true, completion: nil)
        }
    
    func showAlertCreateAccount(message: String) {
            let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
            
            // Tombol Cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                print("User cancelled the action.")
            })
            alert.addAction(cancelAction)
        
        let create = UIAlertAction(title: "Create", style: .default, handler: { _ in
            print("User cancelled the action.")
        })
        alert.addAction(create)
            
            // Menampilkan alert
            present(alert, animated: true, completion: nil)
        }
    
    @IBAction func myUnwindToLogin(unwindSegue: UIStoryboardSegue){
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "usernameLogin")
    }

}
