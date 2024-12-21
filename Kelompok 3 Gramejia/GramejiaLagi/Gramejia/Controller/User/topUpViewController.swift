//
//  topUpViewController.swift
//  Gramejia
//
//  Created by fits on 05/10/24.
//

import UIKit

class topUpViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    let createUserData = CreateUserData()
    @IBOutlet weak var payment_check: UIButton!
    

    @IBAction func add5dollar(_ sender: Any) {
        
        updateNominal(withAmount: 5.0)
    }
    
    @IBAction func add10dollar(_ sender: Any) {
        
        updateNominal(withAmount: 10.0)
    }
    
    @IBAction func add20dollar(_ sender: Any) {
        
        updateNominal(withAmount: 20.0)
    }
    
    @IBAction func add40dollar(_ sender: Any) {
        
        updateNominal(withAmount: 40.0)
    }
    
    @IBAction func add80dollar(_ sender: Any) {
        
        updateNominal(withAmount: 80.0)
    }
    
    @IBAction func add100dollar(_ sender: Any) {
        
        updateNominal(withAmount: 100.0)
    }
    
    func updateNominal(withAmount amount: Double){
        
        var currentAmmount = Double(nominalTF.text!) ?? 0.0
        
        currentAmmount += amount
        nominalTF.text = String(format: "%.2f", currentAmmount)
        
    }
    
    
    
    @IBOutlet weak var nominalTF: UITextField!
    
    @IBAction func payment_check(_ sender: Any) {
        guard let moneytext = nominalTF.text, !moneytext.isEmpty else {
                showAlertfield(message: "Please insert the nominal")
                return
            }

            guard let money = Double(moneytext), money > 0 else {
                showAlertfield(message: "Please enter a valid amount")
                return
            }

            let user = UserDefaults.standard.string(forKey: "usernameLogin")!
            
            if createUserData.updateBalanceForUsername(username: user, newBalance: money) {
                performSegue(withIdentifier: "topUpConfirmed", sender: self)
            }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let moneytext = nominalTF.text, let money = Double(moneytext), money > 0 else {
            showAlertfield(message: "Please enter a valid amount")
            return
        }
        if segue.identifier == "topUpConfirmed" {
            if let destinationVC = segue.destination as? paymentTopUpViewController {
                destinationVC.nominal = money
            }
        }
    }

    
    func showAlertfield(message: String) {
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        
        // Menampilkan alert
        present(alert, animated: true)
    }
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menambahkan gesture recognizer untuk menutup keyboard saat tap di luar
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false // Ini memastikan gesture recognizer tidak memblokir interaksi lainnya
                view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium(),
            .large()
        ]
        
        
        payment_check.layer.cornerRadius = 18
        payment_check.layer.masksToBounds = true
        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true) // Menutup keyboard
       }

}
