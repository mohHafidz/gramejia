//
//  BookCollectionViewCell.swift
//  Gramejia
//
//  Created by prk on 22/11/24.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var namaUI: UILabel!
    @IBOutlet weak var hargaUI: UILabel!
    @IBOutlet weak var priceView: UIView!
    
    
    
    func cardPrice(card: UIView, radius: Double) {
        card.layer.borderColor = UIColor.clear.cgColor
        card.layer.borderWidth = 2.0
        card.layer.cornerRadius = radius
    }
}
