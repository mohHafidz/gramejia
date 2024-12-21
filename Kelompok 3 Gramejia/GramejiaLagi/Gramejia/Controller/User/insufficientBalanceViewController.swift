//
//  insufficientBalanceViewController.swift
//  Gramejia
//
//  Created by prk on 11/12/24.
//

import UIKit

class insufficientBalanceViewController: UIViewController, UISheetPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sheetController = presentationController as? UISheetPresentationController {
            sheetPresentationController.delegate = self
            sheetPresentationController.selectedDetentIdentifier = .medium
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [
                .medium(),
                .large()
            ]

        }
    }
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
