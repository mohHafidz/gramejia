//
//  successPopUpViewController.swift
//  Gramejia
//
//  Created by prk on 11/12/24.
//

import UIKit

class successPopUpViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium(),
            .large()
        ]
    }
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(animated: true)
        if let cartVC = self.presentingViewController as? CartViewController {
            cartVC.dismiss(animated: true, completion: nil)
        }
    }
    
}
