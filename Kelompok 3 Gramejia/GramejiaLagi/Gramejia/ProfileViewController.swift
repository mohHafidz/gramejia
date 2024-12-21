import UIKit

class Proflie_scene: UIViewController{
    @IBOutlet weak var balance_cart: UIView!
    

    override func viewDidLoad (){
        super.viewDidLoad()
        
    }
    
    func card(card: UIView) {
        card.layer.borderColor = UIColor.clear.cgColor
        card.layer.borderWidth = 2.0
        card.layer.cornerRadius = 10.0
    }
}
