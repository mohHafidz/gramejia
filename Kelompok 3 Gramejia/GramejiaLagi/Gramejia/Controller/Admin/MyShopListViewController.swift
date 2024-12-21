//
//  MyShopViewController.swift
//  GramejiaLagiFinal
//
//  Created by prk on 02/12/24.
//

import UIKit
import CoreData

class MyShopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var myShopList: UITableView!
    
    @IBOutlet weak var roundedBackground: UIView!
    
    var floatingButton: UIButton!
    var createdBook = CreateBook()
    var username = UserDefaults.standard.string(forKey: "usernameLogin")!
    
    @IBOutlet weak var ButtonBack: UIImageView!
    
    @IBAction func BackButtonToProfile(_ sender: UITapGestureRecognizer) {
        print("ShopBackButton")
        if presentingViewController != nil {
                // Jika ViewController ini ditampilkan sebagai modal
                dismiss(animated: true, completion: nil)
            } else if let navController = navigationController {
                // Jika ViewController berada dalam NavigationController
                navController.popViewController(animated: true)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        loadData()
        setupFloatingButton()
        
        ButtonBack.isUserInteractionEnabled = true
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(BackButtonToProfile(_:)))
            ButtonBack.addGestureRecognizer(tapGestureRecognizer1)
    }
    

    private func setupUI() {
        roundedBackground.roundedCorners([.topLeft, .topRight], radius: 40)
    }
    
    private func configureTableView() {
        myShopList.dataSource = self
        myShopList.delegate = self
    }
    

    private func loadData() {
        createdBook.loadDataTable(username: username)
        myShopList.reloadData()
    }
    

    private func setupFloatingButton() {
        floatingButton = UIButton()
        floatingButton.frame = CGRect(x: view.frame.width - 80, y: view.frame.height - 120, width: 58, height: 58)
        floatingButton.backgroundColor = .systemBlue
        floatingButton.roundedCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
        floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingButton.tintColor = .white
        floatingButton.addTarget(self, action: #selector(floatingButtonPressed), for: .touchUpInside)
        
        view.addSubview(floatingButton)
        
        // Constraints
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 58),
            floatingButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    

    @objc func floatingButtonPressed() {
        if let navigationController = self.navigationController {
            if let addDataPage = storyboard?.instantiateViewController(withIdentifier: "newAddBookPage") {
                print("push")
                navigationController.pushViewController(addDataPage, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createdBook.listShop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookData", for: indexPath) as! bookDataTableViewCell
        let book = createdBook.listShop[indexPath.row]
        cell.bookName.text = book.judul
        cell.bookAuthor.text = book.author
        cell.bookPrice.text = "$ \(book.price)"
        cell.bookImage.image = book.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Implementasi penghapusan data
            createdBook.deleteData(at: indexPath, username: username, listTV: myShopList)
        }
    }
    
    var selectedIndexPath: IndexPath!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Menyimpan indexPath atau informasi lain yang dibutuhkan
                selectedIndexPath = indexPath
                
                // Melakukan segue untuk berpindah ke halaman detail
                performSegue(withIdentifier: "gotodetail", sender: nil)
                
                // Jika Anda ingin melakukan de-selection (hilangkan highlight pada cell setelah dipilih)
                tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotodetail"{
            if let detailBookVC = segue.destination as? BookDetailAdminViewController {
                let judul = createdBook.listShop[selectedIndexPath.row].judul
                detailBookVC.judul = judul
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData() // Update saldo setiap kali view muncul
    }
}
