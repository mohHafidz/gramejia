//
//  BookDetailAdminViewController.swift
//  Gramejia
//
//  Created by prk on 03/12/24.
//

import UIKit

class BookDetailAdminViewController : UIViewController{
    
    var createBook = CreateBook()
    
    var judul : String = ""
    var username = UserDefaults.standard.string(forKey: "usernameLogin")!
    
    @IBOutlet weak var backgroundViewAdmin: UIView!
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    @IBOutlet weak var bookLanguage: UILabel!
    @IBOutlet weak var bookPages: UILabel!
    @IBOutlet weak var bookOverview: UILabel!
    @IBOutlet weak var bookPublisher: UILabel!
    @IBOutlet weak var bookAuthorOverview: UILabel!
    @IBOutlet weak var bookAuthorImage: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var bookPrice: UILabel!
    
    @IBAction func EditBookButton(_ sender: Any) {
        performSegue(withIdentifier: "gotoupdate", sender: self)
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            setupView()
        bookImage.image = createBook.listDetailBook[0].image
        bookName.text = createBook.listDetailBook[0].judul
        bookAuthor.text = createBook.listDetailBook[0].author
        bookGenre.text = createBook.listDetailBook[0].genre
        bookLanguage.text = createBook.listDetailBook[0].language
        bookPages.text = "\(createBook.listDetailBook[0].page)"
        bookOverview.text = createBook.listDetailBook[0].publisher
        bookOverview.text = createBook.listDetailBook[0].overview
        author.text = "by \(createBook.listDetailBook[0].author)"
        bookAuthorImage.image = createBook.listDetailBook[0].image_author
        bookAuthorOverview.text = createBook.listDetailBook[0].about
        bookPrice.text = "$\(createBook.listDetailBook[0].price)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(tapGesture)
        
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoupdate"{
            if let detailBookVC = segue.destination as? updateViewController {
                detailBookVC.oldJudul = judul
            }
        }
    }

        private func setupUI() {
            backgroundViewAdmin.roundedCorners1([.topLeft], radius: 100)
        }
    
    func setupView() {
        createBook.fetchBooksDetailAdmin(byTitle: judul, username: username)
    }

    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension UIView {
    func roundedCorners1(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            var cornerMask = CACornerMask()
            if corners.contains(.topLeft) {
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight) {
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
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
