//
//  profile.swift
//  Gramejia
//
//  Created by fits on 28/09/24.
//

import UIKit

class profile: UIViewController{
    var createUserData = CreateUserData()
    @IBOutlet weak var balanceLBL: UILabel!
    @IBOutlet weak var balance_cart: UIView!
    @IBOutlet weak var list_setting: UIView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var emailLBL: UILabel!
    @IBAction func tes(_ sender: UITapGestureRecognizer) {
    }
    override func viewDidLoad() {
        card(card: balance_cart)
        roundedTopCorners(for: list_setting)
        
        usernameLBL.text = "Hi, \(UserDefaults.standard.string(forKey: "usernameLogin")!)"
        
        emailLBL.text = createUserData.getEmailForUsername(username: UserDefaults.standard.string(forKey: "usernameLogin")!)
        
        updateBalance()
    }
    
    public func updateBalance(){
        if let username = UserDefaults.standard.string(forKey: "usernameLogin") {
            balanceLBL.text = "$\(createUserData.getBalanceForUsername(username: username) ?? 0.0)"
        }
    }
    
    func card(card: UIView) {
        card.layer.borderColor = UIColor.clear.cgColor
        card.layer.borderWidth = 2.0
        card.layer.cornerRadius = 18.0
    }
    
    func roundedTopCorners(for view: UIView) {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 40, height: 40))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }

    

    @IBAction func handleViewTap(_ sender: Any) {
        print("klik cart")
        let cart = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(cart, animated: true)
    }
    
    
    @IBAction func MyShopButton(_ sender: Any) {
        print("klik shop")
        
        let shop = storyboard?.instantiateViewController(withIdentifier: "MyShopListViewController") as! MyShopListViewController
        navigationController?.pushViewController(shop, animated: true)
        
    }
    
    
    @IBAction func MyOrderHistory(_ sender: Any) {
        print("bisa")
        
        let history = storyboard?.instantiateViewController(withIdentifier: "HistoryPageViewController") as! HistoryPageViewController
        navigationController?.pushViewController(history, animated: true)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        balanceLBL.text = "$\(createUserData.getBalanceForUsername(username: UserDefaults.standard.string(forKey: "usernameLogin")!)!)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalance() // Update saldo setiap kali view muncul
    }
    
}
