    import UIKit
    import CoreData


    class HistoryPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        @IBOutlet weak var backButton: UIImageView!
        
        @IBOutlet weak var historyTableView: UITableView!
        
        @IBOutlet weak var roundedCorner: UIView!
        
        var createBook = CreateBook()
        
        var username = UserDefaults.standard.string(forKey: "usernameLogin")!
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            roundedCorner.roundedCorners([.topLeft, .topRight], radius: 40)
            
            historyTableView.delegate = self
            historyTableView.dataSource = self
            
            let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPage))
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(backButtonGesture)
            
            
            
            createBook.fetchOrderListAndCalculateTotal(username: username)
            print("Logged in as: \(username)")
            print(createBook.listHistory.count)
            historyTableView.reloadData()
            
            print(createBook.orderListItem.count)
            
        }
        
        @objc func dismissPage() {
            self.dismiss(animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            createBook.orderListItem.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyData", for: indexPath) as! HistoryPageTableViewCell
            
            let historyItem = createBook.orderListItem[indexPath.row]
            
            cell.titleLabel.text = historyItem.judul
            cell.priceLabel.text = "$\(historyItem.price)"
            cell.quantityLabel.text = "\(historyItem.quantity) Item"
            cell.coverImageView.image = historyItem.gambar
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            170
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let selectedBook = createBook.orderListItem[indexPath.row]
            performSegue(withIdentifier: "backToDetail", sender: selectedBook)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "backToDetail" {
                if let destinationVC = segue.destination as? BookDetailsViewController {
                    if let selectedBook = sender as? CreateBook.orderList {
                        destinationVC.judul = selectedBook.judul
                    }
                }
            }
        }
    }
