//
//  CustomTableViewCell.swift
//  Gramejia
//
//  Created by prk on 22/11/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [Book] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! BookCollectionViewCell
        
        cell.hargaUI.text = "\(items[indexPath.row].harga)"
        cell.namaUI.text = items[indexPath.row].nama
        cell.imageUI.image = items[indexPath.row].image
                return cell
    }
    
    func configure(items: [Book]) {
           self.items = items
           collectionView.reloadData()
       }
       

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Set layout untuk 2 kolom
        setupCollectionViewLayout()
        // Initialization code
    }
    
    func setupCollectionViewLayout() {
            let flowLayout = UICollectionViewFlowLayout()
            
            // Ukuran setiap item adalah setengah dari lebar collection view (2 kolom)
            flowLayout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 10) / 2, height: 200)
            flowLayout.minimumInteritemSpacing = 10  // Spasi antar item horizontal
            flowLayout.minimumLineSpacing = 10  // Spasi antar item vertikal
            
            collectionView.collectionViewLayout = flowLayout
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
