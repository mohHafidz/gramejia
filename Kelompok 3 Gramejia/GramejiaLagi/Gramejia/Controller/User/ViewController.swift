import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if createdBook.listItem.count > 3 {
            return 3
        }
        
        return createdBook.listItem.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionView", for: indexPath) as! BookCollectionViewCell
        
        // Check if the outlets are properly connected and not nil
        guard let hargaUI = cell.hargaUI,
              let namaUI = cell.namaUI,
              let imageUI = cell.imageUI,
              let priceView = cell.priceView else {
            fatalError("One of the UI elements is not connected properly!")
        }
     
            cell.layer.cornerRadius = 8.0  // Jika ingin sudut yang melengkung
            cell.layer.masksToBounds = true  // Agar border mengikuti bentuk sudut yang melengkung
        
        let book = createdBook.listItem[indexPath.row]
        
        // Set the UI elements
        hargaUI.text = "$\(book.harga)"
        namaUI.text = book.nama
        imageUI.image = book.image
        cell.cardPrice(card: priceView, radius: 8)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = createdBook.listItem[indexPath.row]
        performSegue(withIdentifier: "gotodetail", sender: selectedBook)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotodetail" {
            if let destinationVC = segue.destination as? BookDetailsViewController {
                if let selectedBook = sender as? CreateBook.Book {
                    destinationVC.judul = selectedBook.nama
                }
            }
        }
    }
    
    var createdBook = CreateBook()
    
    @IBOutlet weak var view_foryou: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var viewer_book: UIView!
    @IBOutlet weak var newCollectionCV: UICollectionView!
    @IBOutlet weak var tes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Menambahkan border pada view_foryou
        card(card: view_foryou, radius: 10.0)
        
        card(card: viewer_book, radius: 10)
        
        roundedTopCorners(for: background)
        
        applyGradient()
        
        createdBook.loadData(collection: newCollectionCV)
        
        setupCollectionViewLayout()
        
        newCollectionCV.dataSource = self
        newCollectionCV.delegate = self
    }
    

    func card(card: UIView, radius: Double) {
        card.layer.borderColor = UIColor.clear.cgColor
        card.layer.borderWidth = 2.0
        card.layer.cornerRadius = radius
    }
    
    func roundedTopCorners(for view: UIView) {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.bottomLeft],
                                    cornerRadii: CGSize(width: 61, height: 61))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }
    
    private func applyGradient() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = background.bounds // Menggunakan bounds dari background
            gradientLayer.colors = [
                UIColor(red: 42/255, green: 23/255, blue: 129/255, alpha: 1).cgColor,
                UIColor(red: 76/255, green: 41/255, blue: 231/255, alpha: 1).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // Dari atas
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)   // Ke bawah
            background.layer.insertSublayer(gradientLayer, at: 0) // Memasukkan ke background layer
        }
    
    @IBAction func unwindViewController(unwindSegue: UIStoryboardSegue){
        
    }
    
    func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: (self.newCollectionCV.frame.size.width - 10) / 2, height: 400)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        newCollectionCV.collectionViewLayout = flowLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createdBook.loadData(collection: newCollectionCV) // Update saldo setiap kali view muncul
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10
        return CGSize(width: width, height: 200)
    }
}
