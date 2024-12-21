//
//  AddNewBookViewController.swift
//  Gramejia
//
//  Created by prk on 03/12/24.
//

import UIKit

class AddNewBookViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var createBook = CreateBook()
    
    @IBOutlet weak var bookName: UITextField!
    @IBOutlet weak var bookGenre: UITextField!
    @IBOutlet weak var bookLanguage: UITextField!
    @IBOutlet weak var bookPages: UITextField!
    @IBOutlet weak var bookPublisher: UITextField!
    @IBOutlet weak var bookOverview: UITextField!
    @IBOutlet weak var bookAuthor: UITextField!
    @IBOutlet weak var bookAboutAuthor: UITextField!
    @IBOutlet weak var bookPrice: UITextField!
    @IBOutlet weak var BookImagePreview: UIImageView!
    @IBOutlet weak var bookAuthorImagePreview: UIImageView!
    
    var username = UserDefaults.standard.string(forKey: "usernameLogin")
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    
    @IBAction func addBookButton(_ sender: Any) {
        createData()
    }
    
    
    func createData()
    {
        let about = bookAboutAuthor.text
        let judul = bookName.text
        let author = bookAuthor.text
        let genre = bookGenre.text
        let language = bookLanguage.text
        let overview = bookOverview.text
        let pageTxt = bookPages.text
        let page = Int(pageTxt ?? "0")
        let priceTxt = bookPrice.text
        let price = Double(priceTxt!)
        let image = BookImagePreview.image
        let image_author = bookAuthorImagePreview.image
        let publisher = bookPublisher.text
        guard let about = about, !about.isEmpty else {
                showAlert(message: "About author is required")
                return
            }
            
            guard let judul = judul, !judul.isEmpty else {
                showAlert(message: "Name is required")
                return
            }
            
            guard let author = author, !author.isEmpty else {
                showAlert(message: "Author is required")
                return
            }
            
            guard let genre = genre, !genre.isEmpty else {
                showAlert(message: "Genre is required")
                return
            }
            
            guard let language = language, !language.isEmpty else {
                showAlert(message: "Language is required")
                return
            }
            
            guard let overview = overview, !overview.isEmpty else {
                showAlert(message: "Overview is required")
                return
            }
            
            guard let publisher = publisher, !publisher.isEmpty else {
                showAlert(message: "Publisher is required")
                return
            }
        
        guard let pageTxt = bookPages.text, !pageTxt.isEmpty, let page = Int(pageTxt), page > 0 else {
                showAlert(message: "Page must be a valid number greater than 0")
                return
            }

        guard let priceTxt = bookPrice.text, !priceTxt.isEmpty, let price = Double(priceTxt), price > 0 else {
                showAlert(message: "Price must be a valid number greater than 0")
                return
            }
        
        guard (image?.jpegData(compressionQuality: 1.0) != nil) else {
                showAlert(message: "Please select a valid image for the book")
                return
            }

        guard (image_author?.jpegData(compressionQuality: 1.0) != nil) else {
                showAlert(message: "Please select a valid image for the author")
                return
            }
        
        createBook.addData(judul: judul, author: author, price: price, genre: genre, about: about, language: language, overview: overview, page: page, publisher: publisher, image: image!, imageAuthor: image_author!, username: username!, from: self)
        
    }
    
    
    @IBAction func UploadBookImage(_ sender: Any) {
        presentImagePicker(for: BookImagePreview)
    }
    
    
    
    @IBAction func UploadAuthorImage(_ sender: Any) {
        presentImagePicker(for: bookAuthorImagePreview)
    }
    
    var pickerView: UIImageView?

    func presentImagePicker(for imageView: UIImageView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        pickerView = imageView
        
        present(imagePickerController, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerView = nil
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let resizedImage = resizeImage(image: selectedImage, targetSize: CGSize(width: 133, height: 122))
        
            if let imageView = pickerView {
                imageView.image = resizedImage
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    
    // alert
    func showAlert(message: String)
    {
        let alert = UIAlertController(title: "Invalid Data", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        {
            _ in
            print("alert dismissed")
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        
        // Menambahkan gesture recognizer untuk menutup keyboard saat tap di luar
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false // Ini memastikan gesture recognizer tidak memblokir interaksi lainnya
                view.addGestureRecognizer(tapGesture)
        
        
        
        view1.layer.borderColor = UIColor(hex: "#4C29E7").cgColor
        view1.layer.borderWidth = 2.0
        
        view2.layer.borderColor = UIColor(hex: "#4C29E7").cgColor
        view2.layer.borderWidth = 2.0
        
        BookImagePreview.translatesAutoresizingMaskIntoConstraints = false
                bookAuthorImagePreview.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    BookImagePreview.widthAnchor.constraint(equalToConstant: 133),
                    BookImagePreview.heightAnchor.constraint(equalToConstant: 122),
                    bookAuthorImagePreview.widthAnchor.constraint(equalToConstant: 133),
                    bookAuthorImagePreview.heightAnchor.constraint(equalToConstant: 122)
                ])
                
                BookImagePreview.contentMode = .scaleAspectFit
                bookAuthorImagePreview.contentMode = .scaleAspectFit
        
        setUpPlaceholderTextColor(for: bookName, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookGenre, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookLanguage, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookPages, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookPublisher, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookOverview, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookAuthor, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookAboutAuthor, color: UIColor(hex: "FFFFFF"))
        setUpPlaceholderTextColor(for: bookPrice, color: UIColor(hex: "FFFFFF"))
        
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true) // Menutup keyboard
       }
    
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            
            var newSize: CGSize
            if widthRatio > heightRatio {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            }
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
    
    func setUpPlaceholderTextColor (for textfield: UITextField, color: UIColor){
        let placeholderText = textfield.placeholder ?? ""
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
    
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex  .trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
