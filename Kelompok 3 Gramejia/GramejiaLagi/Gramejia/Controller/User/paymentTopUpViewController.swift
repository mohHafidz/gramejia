//
//  paymentTopUpViewController.swift
//  Gramejia
//
//  Created by fits on 07/10/24.
//

import UIKit

class paymentTopUpViewController: UIViewController {
    
    var nominal : Double = 0

    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var nominalLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLBL.text = UserDefaults.standard.string(forKey: "usernameLogin")!
        nominalLBL.text = "$\(nominal)"
        roundedTopCorners(for: BackgroundView)
    }
    
    func roundedTopCorners(for view: UIView) {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 40, height: 40))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }
    
}
