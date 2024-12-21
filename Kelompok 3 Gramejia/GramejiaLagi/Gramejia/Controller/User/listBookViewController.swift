//
//  listBookViewController.swift
//  Gramejia
//
//  Created by fits on 01/12/24.
//

import UIKit

class listBookViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createBook.listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! BookCollectionViewCell
        
        cell.layer.cornerRadius = 8.0  // Jika ingin sudut yang melengkung
        cell.layer.masksToBounds = true  // Agar border mengikuti bentuk sudut yang melengkung
        
        let book = createBook.listItem[indexPath.row]
        cell.hargaUI.text = "$\(book.harga)"
        cell.namaUI.text = book.nama
        cell.imageUI.image = book.image
        cell.cardPrice(card: cell.priceView, radius: 8)
        
        return cell
    }
    
    var createBook = CreateBook()

    @IBOutlet weak var Booklist: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        
        Booklist.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        roundedTopCorners(for: Booklist)
        
        createBook.loadData(collection: collectionView)

        // Do any additional setup after loading the view.
    }
    
    func roundedTopCorners(for view: UIView) {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.bottomLeft],
                                    cornerRadii: CGSize(width: 61, height: 61))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }
    
    
    func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 10) / 2, height: 200)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = createBook.listItem[indexPath.row]
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
    
    func card(card: UIView) {
        card.layer.borderColor = UIColor.clear.cgColor
        card.layer.borderWidth = 2.0
        card.layer.cornerRadius = 18.0
    }

}

extension listBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10
        return CGSize(width: width, height: 200)
    }
}
