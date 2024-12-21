//
//  BookDetailsViewController.swift
//  bookdetails
//
//  Created by prk on 01/10/24.
//

import UIKit
import CoreData

class BookDetailsViewController: UIViewController{
    
    var context: NSManagedObjectContext!
    
    var createdBook = CreateBook()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageBookIV: UIImageView!
    @IBOutlet weak var judulLBL: UILabel!
    @IBOutlet weak var authorLBL: UILabel!
    @IBOutlet weak var genreLBL: UILabel!
    @IBOutlet weak var languageLBL: UILabel!
    @IBOutlet weak var pageLBL: UILabel!
    @IBOutlet weak var publisherLBL: UILabel!
    @IBOutlet weak var overviewLBL: UILabel!
    @IBOutlet weak var author2LBL: UILabel!
    @IBOutlet weak var imageAuthorIV: UIImageView!
    @IBOutlet weak var aboutAuthorLBL: UILabel!
    @IBOutlet weak var price: UIButton!
    @IBAction func BuyBTN(_ sender: Any) {
        createdBook.Buy(username: UserDefaults.standard.string(forKey: "usernameLogin")!, judul: judul)
        showAlertfield(message: "This book successfully added to cart")
    }
    
    @IBOutlet weak var backBTN: UIImageView!
    
    var judul:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.roundedCorners([.topLeft], radius: 100)
        
        backBTN.isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backToViewController(_:)))
        backBTN.addGestureRecognizer(tapGestureRecognizer)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        
        // Cek apakah context berhasil diinisialisasi
        if context == nil {
            print("Context is nil!")
            // Jika context nil, Anda bisa memberikan penanganan tambahan jika diperlukan.
        }
        
        createdBook.fetchBooks(byTitle: judul)
        
        imageBookIV.image = createdBook.listDetailBook[0].image
        judulLBL.text = createdBook.listDetailBook[0].judul
        authorLBL.text = createdBook.listDetailBook[0].author
        genreLBL.text = createdBook.listDetailBook[0].genre
        languageLBL.text = createdBook.listDetailBook[0].language
        pageLBL.text = "\(createdBook.listDetailBook[0].page)"
        publisherLBL.text = createdBook.listDetailBook[0].publisher
        overviewLBL.text = createdBook.listDetailBook[0].overview
        author2LBL.text = createdBook.listDetailBook[0].author
        imageAuthorIV.image = createdBook.listDetailBook[0].image_author
        aboutAuthorLBL.text = createdBook.listDetailBook[0].about
        price.setTitle("Buy Book for $\(createdBook.listDetailBook[0].price)", for: .normal)

    }

//    @IBAction func back(_ sender: UITapGestureRecognizer) {
//        print("klik")
//        if presentingViewController != nil {
//                // Jika ViewController ini ditampilkan sebagai modal
//                dismiss(animated: true, completion: nil)
//            } else if let navController = navigationController {
//                // Jika ViewController berada dalam NavigationController
//                navController.popViewController(animated: true)
//            }
//    }
    
    @IBAction func backToViewController(_ sender: UITapGestureRecognizer) {
        print("klik")
        if presentingViewController != nil {
                // Jika ViewController ini ditampilkan sebagai modal
                dismiss(animated: true, completion: nil)
            } else if let navController = navigationController {
                // Jika ViewController berada dalam NavigationController
                navController.popViewController(animated: true)
            }
    }
    
    func showAlertfield(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        // Tombol Cancel
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(cancelAction)
        
        let gocart = UIAlertAction(title: "Go", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "gotocart", sender: self)
        })
        alert.addAction(gocart)
        
        // Menampilkan alert
        present(alert, animated: true, completion: nil)
    }
}

    extension UIView {
        
        func roundedCorners(_ corners: UIRectCorner, radius: CGFloat) {
            if #available(iOS 11, *) {
                var cornerMask = CACornerMask()
                if(corners.contains(.topLeft)){
                    cornerMask.insert(.layerMinXMinYCorner)
                }
                if(corners.contains(.topRight)){
                    cornerMask.insert(.layerMaxXMinYCorner)
                }
                if(corners.contains(.bottomLeft)){
                    cornerMask.insert(.layerMinXMaxYCorner)
                }
                if(corners.contains(.bottomRight)){
                    cornerMask.insert(.layerMaxXMaxYCorner)
                }
                self.layer.cornerRadius = radius
                self.layer.maskedCorners = cornerMask
            } else {
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                self.layer.mask = mask
            }
        }
        
    }
