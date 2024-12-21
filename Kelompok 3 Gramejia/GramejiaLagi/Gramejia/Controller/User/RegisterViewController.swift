//
//  RegisterViewController.swift
//  Gramejia
//
//  Created by fits on 13/10/24.
//

import UIKit


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var UsernameField: UITextField!
    
    @IBOutlet weak var EmailField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    var createUserData = CreateUserData()

    var showPassword = true
    
    var showConfirmPassword = true
    
    @IBAction func regisBTN(_ sender: Any) {
        let email = EmailField.text
        let user = UsernameField.text
        let password = PasswordField.text
        let confirm = ConfirmPassword.text
        
        // Periksa apakah ada field yang kosong
        if email?.isEmpty == true || user?.isEmpty == true || password?.isEmpty == true || confirm?.isEmpty == true {
            showAlertWithHandler(message: "Every field must be filled in")
        } else {
            // Periksa apakah password dan confirm password cocok
            if password != confirm {
                showAlertWithHandler(message: "Password and Confirm Password doesn’t match")
            } else {
                // Menambahkan user jika semua valid
                createUserData.addUser(email: email!, username: user!, password: password!)
                showAlertSuccess(message: "Thank you for creating an account")
            }
        }
    }
    
    @IBAction func backLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func showAlertWithHandler(message: String) {
        let alert = UIAlertController(title: "Please insert all field", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("User cancelled the action.")
        })
        alert.addAction(cancelAction)
        
        // Menampilkan alert
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(message: String) {
        let alert = UIAlertController(title: "successfully created account", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(cancelAction)
        
        // Menampilkan alert
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menambahkan gesture recognizer untuk menutup keyboard saat tap di luar
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false // Ini memastikan gesture recognizer tidak memblokir interaksi lainnya
                view.addGestureRecognizer(tapGesture)
        
        let usernameImage = UIImage(named:"PersonIcon")
        addTextFieldIconUsernameField(txtField: UsernameField, andImage: usernameImage!)
        
        let EmailImage = UIImage(named: "EmailIcon")
        addTextFieldIconPasswordField(txtField: EmailField, andImage: EmailImage!)
        
        let passwordImage = UIImage(named:"PasswordIcon")
        addTextFieldIconPasswordField(txtField: PasswordField, andImage: passwordImage!)
        
        let ConfirmPasswordImage = UIImage(named: "PasswordIcon")
        addTextFieldIconPasswordField(txtField: ConfirmPassword, andImage: ConfirmPasswordImage!)
        
        let UsernamePlaceholder = "Username"
        let PasswordPlaceholder = "Password"
        let EmailPlaceholder = "Email"
        let ConfirmPasswordPlaceHolder = "Confirm Password"
        
        let UsernameAttributes : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        UsernameField.attributedPlaceholder = NSAttributedString(string: UsernamePlaceholder , attributes: UsernameAttributes)
        
        let EmailAttributes : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        EmailField.attributedPlaceholder = NSAttributedString(string: EmailPlaceholder, attributes: EmailAttributes)
        
        let PasswordAttributes : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        PasswordField.attributedPlaceholder = NSAttributedString(string: PasswordPlaceholder , attributes: PasswordAttributes)
        
        let ConfirmPasswordAttributes : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        ConfirmPassword.attributedPlaceholder = NSAttributedString(string: ConfirmPasswordPlaceHolder, attributes: ConfirmPasswordAttributes)
        
        addShowHidePassowrd(to: PasswordField)
        addShowHidePassowrd(to: ConfirmPassword)
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true) // Menutup keyboard
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
        if sender.superview?.superview == PasswordField {
            showPassword.toggle()
            PasswordField.isSecureTextEntry = showPassword
            let image = showPassword ? UIImage(named: "close") : UIImage(named: "open")
            sender.setImage(image, for: .normal)
        } else {
            showConfirmPassword.toggle()
            ConfirmPassword.isSecureTextEntry = showConfirmPassword
            let image = showConfirmPassword ? UIImage(named: "close") : UIImage(named: "open")
            sender.setImage(image, for: .normal)
        }
    }
    
    func addTextFieldIconUsernameField(txtField: UITextField, andImage img: UIImage) {
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

    func addTextFieldIconPasswordField(txtField: UITextField, andImage img: UIImage) {
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

}
