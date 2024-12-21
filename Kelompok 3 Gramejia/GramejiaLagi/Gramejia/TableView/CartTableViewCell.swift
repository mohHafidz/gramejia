import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var namaUI: UILabel!
    @IBOutlet weak var hargaUI: UILabel!
    @IBOutlet weak var countItem: UIStepper!
    @IBOutlet weak var quantityUI: UILabel!
    
    var cartItem: (judul: String, image: UIImage, quantity: Int, totalHarga: Double)?
    
    var username = UserDefaults.standard.string(forKey: "usernameLogin")!
    
    // Closure untuk mengirimkan nilai stepper yang baru ke controller
    var updateQuantity: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Menambahkan target untuk stepper agar dapat menangani perubahan nilai
        countItem.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        // Set nilai stepper sesuai dengan quantity item pada cartItem, jika ada
        if let cartItem = cartItem {
            countItem.value = Double(cartItem.quantity)  // Set nilai stepper ke quantity yang ada
            quantityUI.text = "\(cartItem.quantity)"     // Set label quantity sesuai data yang ada
        }
    }
    
    @objc func stepperValueChanged() {
        // Memperbarui label dengan nilai stepper yang baru
        let newQuantity = Int(countItem.value)
        quantityUI.text = "\(newQuantity)"
        
        // Mengirim nilai baru ke controller melalui closure
        updateQuantity?(newQuantity)
        
        // Update quantity dalam cartItem jika diperlukan
        if var cartItem = cartItem {
            cartItem.quantity = newQuantity
            self.cartItem = cartItem  // Memperbarui cartItem dengan nilai baru
        }
    }
}
