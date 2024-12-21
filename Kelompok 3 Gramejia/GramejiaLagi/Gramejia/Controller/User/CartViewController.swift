//
//  CartViewController.swift
//  Gramejia
//
//  Created by fits on 04/10/24.
//

import UIKit

var createBook = CreateBook()

class CartViewController: UIViewController,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        createBook.listCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cart", for: indexPath) as! CartTableViewCell
            
            let cartItem = createBook.listCart[indexPath.row]
            
            // Mengonfigurasi cell
            cell.imageUI.image = cartItem.image
            cell.namaUI.text = cartItem.judul
            cell.hargaUI.text = "$\(cartItem.harga)"
            cell.quantityUI.text = "\(cartItem.quantity)"
            
            // Set nilai stepper sesuai dengan quantity
            cell.countItem.value = Double(cartItem.quantity)  // Stepper diatur ke quantity yang ada
            
            // Menetapkan closure untuk memperbarui quantity
            cell.updateQuantity = { [weak self] newQuantity in
                // Memperbarui quantity di Core Data
                createBook.updateCartItemQuantity(username: self?.username ?? "", judul: cartItem.judul, newQuantity: newQuantity)
                
                // Memperbarui listCart di array
                createBook.listCart[indexPath.row].quantity = newQuantity
                
                // Refresh tabel setelah quantity diperbarui
                self?.fetchCartItems()
                self?.updateTotalPrice()
            }
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Menghapus item dari data source
                
                createBook.deleteCartItem(at: indexPath, username: username)
                
                // Menghapus row dari tabel
                cartTable.deleteRows(at: [indexPath], with: .automatic)
                fetchCartItems()
                updateTotalPrice()
                itemSelect()
            }
        }
    
    var username = UserDefaults.standard.string(forKey: "usernameLogin")!
    
    var money = CreateUserData().getBalanceForUsername(username:  UserDefaults.standard.string(forKey: "usernameLogin")!)
    
    var totalHarga : Double = 0
    
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var price_cart: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedItemLNL: UILabel!
    @IBOutlet weak var totalPriceLBL: UILabel!
    
    @IBAction func BuyBTN(_ sender: Any) {
        if money! < totalHarga{
            performSegue(withIdentifier: "insufficientBalanceSegue", sender: self)
        } else {
            createBook.moveToOrderListAndDeleteCartItems(username: username)
//            showAlertfieldSuccess(message: "Thank you to check out your book")
            performSegue(withIdentifier: "confirmPayment", sender: self)
            fetchCartItems()
            itemSelect()
            updateTotalPrice()
        }
    }
    
    override func viewDidLoad() {
        
        addTopShadow(to: price_cart)
        
        imageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped(_:)))
            imageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        cartTable.dataSource = self
        
        roundedTopCorners(for: cartTable)
        
        fetchCartItems()
        
        itemSelect()
        
        updateTotalPrice()
    }
    
    func showAlertfield(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(cancelAction)
        
        // Menampilkan alert
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertfieldSuccess(message: String) {
        let alert = UIAlertController(title: "Thank you", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(cancelAction)
        
        // Menampilkan alert
        present(alert, animated: true, completion: nil)
    }
    
    func updateTotalPrice() {
            // Calculate the total price by summing up the price of each cart item
            let totalPrice = createBook.listCart.reduce(0) { (result, cartItem) -> Double in
                return result + (cartItem.harga * Double(cartItem.quantity))
            }
            
            // Display the total price in the label
        totalPriceLBL.text = "Total: $\(String(format: "%.2f", totalPrice))"
        totalHarga = totalPrice
        }
    
    
    
    func itemSelect(){
        selectedItemLNL.text = "Selected Item (\(createBook.listCart.count))"
    }
    
    func fetchCartItems() {
            // Mengambil data dari CreateBook.fetchCardItem
        createBook.fetchCardItem(username: username)
            
            // Reload table view setelah data dimuat
        cartTable.reloadData()
    }
    
    func roundedTopCorners(for view: UIView) {
        // Pastikan view sudah memiliki bounds yang valid sebelum melakukan modifikasi
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 40, height: 40))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    func addTopShadow(to view: UIView) {
            view.layer.shadowColor = UIColor.black.cgColor // Warna bayangan
            view.layer.shadowOpacity = 0.3 // Opasitas bayangan
            view.layer.shadowOffset = CGSize(width: 0, height: -2) // Offset bayangan ke atas
            view.layer.shadowRadius = 4 // Radius blur bayangan
            view.layer.masksToBounds = false // Pastikan bayangan bisa terlihat
        }

    @IBAction func backButtonTapped(_ sender: UITapGestureRecognizer) {
        print("klik back")
        if presentingViewController != nil {
                // Jika ViewController ini ditampilkan sebagai modal
                dismiss(animated: true, completion: nil)
            } else if let navController = navigationController {
                // Jika ViewController berada dalam NavigationController
                navController.popViewController(animated: true)
            }
    }
    

}


