import UIKit

class BookListViewController: UIViewController, UICollectionViewDataSource, UITableViewDelegate, UICollectionViewDelegate {
    
    var createBook = CreateBook()
    
    
    @IBOutlet weak var BookList: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BookList.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupCollectionViewLayout()
        
        card(card: BookList)
        
        
//        createBook.loadData(collection: collectionView)
    }
    
    func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 10) / 2, height: 200)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createBook.listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! BookCollectionViewCell
        
        let book = createBook.listItem[indexPath.row]
        cell.hargaUI.text = "\(book.harga)"
        cell.namaUI.text = book.nama
        cell.imageUI.image = book.image
        cell.cardPrice(card: cell.priceView, radius: 8)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = createBook.listItem[indexPath.row]
        performSegue(withIdentifier: "gotodetail", sender: selectedBook)
    }
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotodetail" {
            if let destinationVC = segue.destination as? BookDetailsViewController {
                if let selectedBook = sender as? CreateBook.Book {
                    destinationVC.judul = selectedBook.nama
                }
            }
        }
    }
}

// Fungsi untuk styling card
func card(card: UIView) {
    card.layer.borderColor = UIColor.clear.cgColor
    card.layer.borderWidth = 2.0
    card.layer.cornerRadius = 18.0
}

extension BookListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10
        return CGSize(width: width, height: 200)
    }
}
