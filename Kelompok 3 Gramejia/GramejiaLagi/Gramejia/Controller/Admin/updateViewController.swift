//
//  updateViewController.swift
//  Gramejia
//
//  Created by fits on 07/12/24.
//

import UIKit

class updateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var oldJudul : String = ""
    
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
    @IBAction func update(_ sender: Any) {
        
        guard let about = bookAboutAuthor.text, !about.isEmpty else {
                print("About author is empty")
            showAlertData(message: "About author must not empty")
                return
            }
            guard let judul = bookName.text, !judul.isEmpty else {
                print("Title is empty")
                showAlertData(message: "Name must not empty")
                return
            }
            guard let author = bookAuthor.text, !author.isEmpty else {
                print("Author is empty")
                showAlertData(message: "Author must not empty")
                return
            }
            guard let genre = bookGenre.text, !genre.isEmpty else {
                print("Genre is empty")
                showAlertData(message: "Genre must not empty")
                return
            }
            guard let language = bookLanguage.text, !language.isEmpty else {
                print("Language is empty")
                showAlertData(message: "Language must not empty")
                return
            }
            guard let overview = bookOverview.text, !overview.isEmpty else {
                print("Overview is empty")
                showAlertData(message: "Overview must not empty")
                return
            }
            guard let pageTxt = bookPages.text, let page = Int(pageTxt), page > 0 else {
                print("Invalid page number")
                showAlertData(message: "Page must be greater than 0")
                return
            }
            guard let priceTxt = bookPrice.text, let price = Double(priceTxt), price > 0.0 else {
                print("Invalid price")
                showAlertData(message: "Price must be greater than 0")
                return
            }
        
            guard let publisher = bookPublisher.text, !publisher.isEmpty else {
            print("Publisher is empty")
                showAlertData(message: "Publisher must be not empty")
            return
            }

            // Safe unwrapping of images
            guard let image = BookImagePreview.image else {
                print("Book image is nil")
                showAlertData(message: "Book image must not empty")
                return
            }
            guard let image_author = bookAuthorImagePreview.image else {
                print("Author image is nil")
                showAlertData(message: "Author image must not empty")
                return
            }
        
        createBook.updateBook(newJudul: judul, author: author, price: price, genre: genre, about: about, language: language, overview: overview, page: page, publisher: publisher, image: image, imageAuthor: image_author, username: username, from: self, judul: oldJudul)
        
        print("update successfull")
    }
    
    var username = UserDefaults.standard.string(forKey: "usernameLogin")!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menambahkan gesture recognizer untuk menutup keyboard saat tap di luar
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGesture.cancelsTouchesInView = false // Ini memastikan gesture recognizer tidak memblokir interaksi lainnya
                view.addGestureRecognizer(tapGesture)
        
        setupView()
        
        BookImagePreview.image = createBook.listDetailBook[0].image
        bookName.text = "\(createBook.listDetailBook[0].judul)"
        bookAuthor.text = createBook.listDetailBook[0].author
        bookGenre.text = createBook.listDetailBook[0].genre
        
        bookLanguage.text = createBook.listDetailBook[0].language
        bookPages.text = "\(createBook.listDetailBook[0].page)"
        bookOverview.text = createBook.listDetailBook[0].publisher
        bookOverview.text = createBook.listDetailBook[0].overview
        bookAuthor.text = "\(createBook.listDetailBook[0].author)"
        
        bookAuthorImagePreview.image = createBook.listDetailBook[0].image_author
        bookAboutAuthor.text = createBook.listDetailBook[0].about
        bookPrice.text = "\(createBook.listDetailBook[0].price)"
        bookPublisher.text = createBook.listDetailBook[0].publisher
        

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
            bookAuthorImagePreview.heightAnchor.constraint(equalToConstant: 122)])
                
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
    
    func setupView() {
        createBook.fetchBooksDetailAdmin(byTitle: oldJudul, username: username)
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
    
    @IBAction func UpdateBookImage(_ sender: Any) {
        print("Book")
        presentImagePicker(for: BookImagePreview)
    }
    
    
    @IBAction func UpdateAuthorImage(_ sender: Any) {
        print("Author")
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

    func showAlertData(message: String)
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

}


