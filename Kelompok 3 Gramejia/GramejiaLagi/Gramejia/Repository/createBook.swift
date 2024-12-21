//
//  createBook.swift
//  Gramejia
//
//  Created by fits on 01/12/24.
//

import UIKit
import CoreData

class CreateBook{
    
    struct detailBook{
        var about: String
        var author: String
        var genre: String
        var image: UIImage
        var image_author: UIImage
        var judul: String
        var language: String
        var overview: String
        var page: Int
        var price: Double
        var publisher: String
    }
    
    struct Book {
        var image: UIImage
        var nama: String
        var harga: Double
    }
    
    struct Cart{
        var judul: String
        var quantity: Int
        var image: UIImage
        var harga: Double
    }
    
    struct orderList{
        var judul: String
        var gambar: UIImage
        var price: Double
        var quantity: Int
    }
    
    struct myShopBook{
        var image : UIImage
        var judul : String
        var price : Double
        var author : String
    }
    
    struct historyList{
        var image : UIImage
        var title : String
        var price : Double
        var quantity : Int32
    }
    
    var listItem = [Book]()
    var listShop = [myShopBook]()
    var listDetailBook = [detailBook]()
    var listCart = [Cart]()
    var orderListItem = [orderList]()
    var listHistory = [historyList]()
    
    var context: NSManagedObjectContext!

    init() {
        // Ambil context dari AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        
        // Cek apakah context berhasil diinisialisasi
        if context == nil {
            print("Context is nil!")
            // Jika context nil, Anda bisa memberikan penanganan tambahan jika diperlukan.
        }
    }
    
    func fetchBooks(byTitle title: String) {
        listDetailBook = [detailBook]()
        
        // Membuat fetch request untuk entitas Catalog
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        
        // Membuat predicate untuk mencari berdasarkan judul
        let predicate = NSPredicate(format: "judul CONTAINS[cd] %@", title)
        request.predicate = predicate
        
        do {
            // Mengambil data dari Core Data dengan filter berdasarkan judul
            let result = try context.fetch(request) as! [NSManagedObject]
            
            // Memetakan hasil fetch ke array data filteredBooks
            for r in result {
                if let judul = r.value(forKey: "judul") as? String,
                   let price = r.value(forKey: "price") as? Double,
                   let imageData = r.value(forKey: "image") as? Data,
                   let image = UIImage(data: imageData),
                   let about = r.value(forKey:"about") as? String,
                   let author = r.value(forKey: "author") as? String,
                   let genre = r.value(forKey: "genre") as? String,
                   let image_author_data = r.value(forKey: "image_author") as? Data,
                   let image_author = UIImage(data: image_author_data),
                   let language = r.value(forKey: "language") as? String,
                   let overview = r.value(forKey: "overview") as? String,
                   let page = r.value(forKey: "page") as? Int,
                   let publisher = r.value(forKey: "publisher") as? String{
                    let data = detailBook(about: about,author: author,genre: genre,image: image,image_author: image_author,judul: judul, language: language, overview: overview, page: page, price: price, publisher: publisher)
                    listDetailBook.append(data)
                }
            }
            
        } catch {
            print("Gagal memuat data: \(error.localizedDescription)")
        }
    }
    
    func loadData(collection: UICollectionView) {
        listItem = [Book]()  // Reset dataList sebelum memuat data baru
        
        // Membuat fetch request untuk entitas Catalog
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        
        do {
            // Mengambil data dari Core Data
            let result = try context.fetch(request) as! [NSManagedObject]
            
            // Memetakan hasil fetch ke array dataList
            for r in result {
                if let judul = r.value(forKey: "judul") as? String,
                   let price = r.value(forKey: "price") as? Double,
                   let imageData = r.value(forKey: "image") as? Data,
                   let image = UIImage(data: imageData) {
                    let data = Book(image: image, nama: judul, harga: price)
                    listItem.append(data)
                }
            }
            
            // Reload tabel setelah data dimuat
            collection.reloadData()
            
        } catch {
            print("Gagal memuat data: \(error.localizedDescription)")
        }
    }
    
    func loadDataTable(username: String) {
        listShop = [myShopBook]()
        
        // Membuat fetch request untuk entitas Catalog
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        let predicate = NSPredicate(format: "username == %@", username)
        request.predicate = predicate
        
        do {
            // Mengambil data dari Core Data
            let result = try context.fetch(request) as! [NSManagedObject]
            
            // Memetakan hasil fetch ke array listItem1
            for r in result {
                if let judul = r.value(forKey: "judul") as? String,
                   let price = r.value(forKey: "price") as? Double,
                   let penulis = r.value(forKey: "author") as? String,
                   let imageData = r.value(forKey: "image") as? Data,
                   let image = UIImage(data: imageData) {
                    let data1 = myShopBook(image: image, judul: judul, price: price, author: penulis)
                    listShop.append(data1)
                }
            }
            
            // Reload tabel setelah data dimuat
            //tableview.reloadData()
            
        } catch {
            print("Gagal memuat data: \(error.localizedDescription)")
        }
    }
    
    func loadDataTableHistory(username: String) {
        
        listHistory = [historyList]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        let predicate = NSPredicate(format: "username == %@", username)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            
            for r in result {
                if let judul = r.value(forKey: "judul") as? String,
                   let price = r.value(forKey: "price") as? Double,
                   let imageData = r.value(forKey: "image") as? Data,
                   let image = UIImage(data: imageData),
                   let quantity = r.value(forKey: "quantity") as? Int32{
                    let data1 = historyList(image: image, title: judul, price: price, quantity: quantity)
                    listHistory.append(data1)
                }
            }

            

        } catch {
            print("Gagal memuat data: \(error.localizedDescription)")
        }
    }
    
    func Buy(username: String, judul: String) {
        // Buat fetch request untuk mencari item dengan username dan judul yang sesuai
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        // Membuat predicate untuk memfilter berdasarkan username dan judul
        let predicate = NSPredicate(format: "username == %@ AND judul == %@", username, judul)
        request.predicate = predicate
        
        do {
            // Fetch data dengan menggunakan request yang telah didefinisikan
            let existingItems = try context.fetch(request)
            
            // Cek apakah sudah ada item yang sesuai dengan predicate
            if let existingItem = existingItems.first as? NSManagedObject { // Casting ke entitas Cart yang benar
                // Jika item sudah ada, tambahkan 1 pada quantity
                let currentQuantity = existingItem.value(forKey: "quantity") as? Int ?? 0
                existingItem.setValue(currentQuantity + 1, forKey: "quantity")
            } else {
                // Jika item belum ada, tambahkan data baru ke Cart
                if let cartEntity = NSEntityDescription.entity(forEntityName: "Cart", in: context) {
                    let newItem = NSManagedObject(entity: cartEntity, insertInto: context)
                    
                    // Menetapkan nilai-nilai untuk entitas baru
                    newItem.setValue(username, forKey: "username")
                    newItem.setValue(judul, forKey: "judul")
                    newItem.setValue(1, forKey: "quantity")  // Mengatur quantity awal ke 1
                }
            }
            
            // Menyimpan data ke Core Data
            try context.save()
            print("Data berhasil disimpan atau diperbarui.")
            
        } catch {
            print("Terjadi error saat melakukan fetch atau menyimpan data: \(error.localizedDescription)")
        }
    }
    
    func fetchCardItem(username: String){
        listCart = [Cart]()
        
        // Membuat fetch request untuk entitas Cart berdasarkan username
        let requestCartData = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let predicate = NSPredicate(format: "username == %@", username)
        requestCartData.predicate = predicate
        
        do {
            // Fetch data Cart berdasarkan username
            let cartResults = try context.fetch(requestCartData) as! [NSManagedObject]
            
            // Looping untuk setiap item Cart
            for cartItem in cartResults {
                if let judul = cartItem.value(forKey: "judul") as? String,
                   let quantity = cartItem.value(forKey: "quantity") as? Int {
                    
                    // Sekarang fetch data dari Catalog berdasarkan judul
                    let requestCatalogData = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
                    let catalogPredicate = NSPredicate(format: "judul == %@", judul)
                    requestCatalogData.predicate = catalogPredicate
                    
                    do {
                        // Fetch data Catalog berdasarkan judul
                        let catalogResults = try context.fetch(requestCatalogData) as! [NSManagedObject]
                        
                        // Ambil harga dan gambar dari entitas Catalog
                        if let catalogItem = catalogResults.first {
                            if let price = catalogItem.value(forKey: "price") as? Double,
                               let imageData = catalogItem.value(forKey: "image") as? Data,
                               let image = UIImage(data: imageData) {
                                
                                // Hitung total harga
                                let totalHarga = price
                                
                                // Menambahkan data ke array cartItems
                                let cartData = Cart(judul: judul, quantity: quantity, image: image, harga: totalHarga)
                                listCart.append(cartData)
                            }
                        }
                        
                    } catch {
                        print("Error fetching data from Catalog: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Error fetching data from Cart: \(error.localizedDescription)")
        }
    }
    
    // Fungsi untuk mengupdate quantity di Core Data
        func updateCartItemQuantity(username: String, judul: String, newQuantity: Int) {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            let predicate = NSPredicate(format: "username == %@ AND judul == %@", username, judul)
            request.predicate = predicate
            
            do {
                let cartItems = try context.fetch(request) as! [NSManagedObject]
                
                if let existingItem = cartItems.first {
                    // Update the quantity value
                    existingItem.setValue(newQuantity, forKey: "quantity")
                    
                    // Save the updated context
                    try context.save()
                    print("Quantity berhasil diperbarui.")
                }
            } catch {
                print("Terjadi error saat memperbarui quantity: \(error.localizedDescription)")
            }
        }

    // Fungsi untuk menghapus data berdasarkan username dan judul
    func deleteCartItem(at indexPath: IndexPath, username: String) {
        // Ambil item yang akan dihapus dari listCart
        let bookToDelete = listCart[indexPath.row]
        
        // Membuat fetch request untuk entitas Cart berdasarkan username dan judul
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        request.predicate = NSPredicate(format: "username == %@ AND judul == %@", username, bookToDelete.judul)
        
        do {
            // Menjalankan fetch request untuk mendapatkan objek yang sesuai
            let results = try context.fetch(request) as! [NSManagedObject]
            
            // Jika ada hasil yang ditemukan, hapus objeknya
            if let cartItem = results.first {
                context.delete(cartItem)
                
                // Menyimpan perubahan ke Core Data
                try context.save()
                print("Item dengan username \(username) dan judul \(bookToDelete.judul) berhasil dihapus.")
                
                // Menghapus item dari listCart (UI)
                listCart.remove(at: indexPath.row)
            } else {
                print("Tidak ada item yang ditemukan untuk username \(username) dan judul \(bookToDelete.judul).")
            }
        } catch {
            // Menangani error jika terjadi kesalahan saat melakukan fetch atau delete
            print("Terjadi kesalahan saat menghapus item: \(error.localizedDescription)")
        }
    }
    
    func moveToOrderListAndDeleteCartItems(username: String) {
        // Pertama, ambil semua data Cart berdasarkan username
        let requestCartData = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let predicate = NSPredicate(format: "username == %@", username)
        requestCartData.predicate = predicate
        
        do {
            // Ambil data Cart yang sesuai dengan username
            let cartItems = try context.fetch(requestCartData) as! [NSManagedObject]
            
            // Cek apakah ada data Cart yang ditemukan
            if cartItems.isEmpty {
                print("Tidak ada item di Cart untuk username \(username).")
                return
            }
            
            // Hitung total harga yang akan dikurangkan dari saldo
            var totalAmount: Double = 0.0
            
            // Iterasi setiap item di Cart dan pindahkan ke OrderList
            for cartItem in cartItems {
                if let judul = cartItem.value(forKey: "judul") as? String,
                   let quantity = cartItem.value(forKey: "quantity") as? Int {
                    
                    // Ambil harga dari Catalog berdasarkan judul
                    let requestCatalog = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
                    let catalogPredicate = NSPredicate(format: "judul == %@", judul)
                    requestCatalog.predicate = catalogPredicate
                    
                    do {
                        // Ambil data Catalog berdasarkan judul
                        let catalogItems = try context.fetch(requestCatalog) as! [NSManagedObject]
                        
                        // Jika data ditemukan, ambil harga dan hitung total
                        if let catalogItem = catalogItems.first,
                           let price = catalogItem.value(forKey: "price") as? Double {
                            
                            // Hitung total harga untuk item ini (quantity * price)
                            let totalPrice = price * Double(quantity)
                            totalAmount += totalPrice  // Tambahkan ke totalAmount
                            
                            // Ambil tanggal saat ini
                            let currentDate = Date()
                            
                            // Mendapatkan entitas OrderList dari Core Data
                            if let orderListEntity = NSEntityDescription.entity(forEntityName: "OrderList", in: context) {
                                // Membuat objek OrderList baru
                                let newOrder = NSManagedObject(entity: orderListEntity, insertInto: context)
                                
                                // Set nilai atribut ke dalam objek OrderList
                                newOrder.setValue(judul, forKey: "judul")
                                newOrder.setValue(username, forKey: "username")
                                newOrder.setValue(quantity, forKey: "quantity")
                                newOrder.setValue(currentDate, forKey: "tanggal")  // Set tanggal saat ini
                                
                                // Simpan data ke Core Data
                                try context.save()
                                print("Data berhasil disalin ke OrderList untuk judul: \(judul), username: \(username).")
                            }
                        }
                    } catch {
                        print("Error fetching data from Catalog: \(error.localizedDescription)")
                    }
                }
            }
            
            // Setelah data berhasil disalin ke OrderList, hapus semua data Cart
            for cartItem in cartItems {
                context.delete(cartItem)
            }
            
            // Simpan perubahan ke Core Data
            try context.save()
            print("Semua item berhasil dihapus dari Cart untuk username \(username).")
            
            // Sekarang kurangi saldo pengguna di entitas Balance
            let requestBalanceData = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
            let balancePredicate = NSPredicate(format: "user == %@", username)
            requestBalanceData.predicate = balancePredicate
            
            do {
                // Ambil data Balance berdasarkan username
                let balanceItems = try context.fetch(requestBalanceData) as! [NSManagedObject]
                
                if let balanceItem = balanceItems.first,
                   let currentBalance = balanceItem.value(forKey: "money") as? Double {
                    
                    // Kurangi saldo dengan totalAmount yang sudah dihitung
                    let newBalance = currentBalance - totalAmount
                    
                    // Update saldo di Core Data
                    balanceItem.setValue(newBalance, forKey: "money")
                    
                    // Simpan perubahan saldo ke Core Data
                    try context.save()
                    print("Saldo berhasil diperbarui. Sisa saldo: \(newBalance)")
                } else {
                    print("Tidak ditemukan entitas Balance untuk username \(username).")
                }
            } catch {
                print("Terjadi error saat mengurangi saldo: \(error.localizedDescription)")
            }
            
        } catch {
            print("Terjadi error saat menyalin data ke OrderList atau menghapus data dari Cart: \(error.localizedDescription)")
        }
    }


    func fetchOrderListAndCalculateTotal(username: String) {
        orderListItem = [orderList]() // Array untuk menampung hasil data yang sudah diproses

        // Membuat fetch request untuk mengambil data dari entitas OrderList berdasarkan username
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderList")
        let predicate = NSPredicate(format: "username == %@", username)
        request.predicate = predicate

        do {
            // Mengambil data dari entitas OrderList berdasarkan username
            let results = try context.fetch(request) as! [NSManagedObject]

            // Iterasi untuk setiap item di OrderList
            for orderItem in results {
                if let judul = orderItem.value(forKey: "judul") as? String,
                   let quantity = orderItem.value(forKey: "quantity") as? Int {

                    // Membuat fetch request untuk mengambil data dari Catalog berdasarkan judul
                    let requestCatalog = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
                    let catalogPredicate = NSPredicate(format: "judul == %@", judul)
                    requestCatalog.predicate = catalogPredicate

                    do {
                        // Mengambil data dari entitas Catalog berdasarkan judul
                        let catalogResults = try context.fetch(requestCatalog) as! [NSManagedObject]

                        // Jika data ditemukan di Catalog, ambil harga dan gambar
                        if let catalogItem = catalogResults.first {
                            if let price = catalogItem.value(forKey: "price") as? Double,
                               let imageData = catalogItem.value(forKey: "image") as? Data,
                               let image = UIImage(data: imageData) {
                                
                                // Menghitung total harga untuk satu barang
                                let totalPrice = price * Double(quantity)
                                
                                // Menyimpan hasil dalam array orderListItems
                                let item = orderList(judul: judul, gambar: image, price: totalPrice, quantity: quantity)
                                orderListItem.append(item)
                            }
                        }
                    } catch {
                        print("Error fetching data from Catalog: \(error.localizedDescription)")
                    }
                }
            }

            // Di sini Anda bisa menggunakan orderListItems untuk memperbarui UI atau melanjutkan pemrosesan lebih lanjut
            // Contoh, cetak hasil untuk setiap item:
//            for item in orderListItem {
//                print("Judul: \(item.judul), Quantity: \(item.quantity), Total Price: \(item.totalPrice), Gambar: \(item.image)")
//            }

        } catch {
            print("Error fetching data from OrderList: \(error.localizedDescription)")
        }
    }
    
    func addData(judul: String, author: String, price: Double, genre: String, about: String, language: String, overview: String, page: Int, publisher: String, image: UIImage, imageAuthor: UIImage, username: String, from viewController: UIViewController){
        
        // Konversi gambar menjadi data (JPEG atau PNG)
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        guard let imageDataAuthor = imageAuthor.jpegData(compressionQuality: 1.0) else { return }
        
        // Mendapatkan entitas Catalog dari Core Data
        let bookEntity = NSEntityDescription.entity(forEntityName: "Catalog", in: context)!
        
        // Membuat objek NSManagedObject untuk entitas Catalog
        let book = NSManagedObject(entity: bookEntity, insertInto: context)
        
        // Set nilai atribut ke dalam objek Core Data
        book.setValue(judul, forKey: "judul")
        book.setValue(author, forKey: "author")
        book.setValue(price, forKey: "price")
        book.setValue(genre, forKey: "genre")
        book.setValue(about, forKey: "about")
        book.setValue(language, forKey: "language")
        book.setValue(overview, forKey: "overview")
        book.setValue(page, forKey: "page")
        book.setValue(publisher, forKey: "publisher")
        book.setValue(imageDataAuthor, forKey: "image_author")
        book.setValue(imageData, forKey: "image")
        book.setValue(username, forKey: "username")
        
        
        do {
            try context.save()  // Simpan data ke Core Data
            print("Data berhasil disimpan!")
            self.showAlertSuccessfull(from: viewController)
        } catch {
            print("Gagal menyimpan data: \(error.localizedDescription)")
        }
    }
    
    func deleteData(at indexPath: IndexPath, username: String, listTV:UITableView) {
        let bookToDelete = listShop[indexPath.row]
        
        // Membuat fetch request untuk mencari entitas yang ingin dihapus
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        
        // Mencari objek yang ingin dihapus berdasarkan judul (atau bisa dengan parameter lain)
        request.predicate = NSPredicate(format: "judul == %@ AND username == %@", bookToDelete.judul, username)
        
        do {
            // Fetch data berdasarkan predicate
            let result = try context.fetch(request)
            
            // Jika ada data yang ditemukan, hapus data tersebut
            if let bookToDeleteObject = result.first as? NSManagedObject {
                context.delete(bookToDeleteObject)
                
                // Simpan perubahan ke Core Data
                try context.save()
                print("Data berhasil dihapus!")
                
                // Hapus data dari dataList dan reload tabel
                listShop.remove(at: indexPath.row)
                listTV.deleteRows(at: [indexPath], with: .automatic)
            }
            
        } catch {
            print("Gagal menghapus data: \(error.localizedDescription)")
        }
    }
    
    func fetchBooksDetailAdmin(byTitle title: String, username: String) {
        listDetailBook = [detailBook]()
        
        // Membuat fetch request untuk entitas Catalog
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        
        // Membuat predicate untuk mencari berdasarkan judul
        let predicate = NSPredicate(format: "judul CONTAINS[cd] %@ AND username == %@", title, username)
        request.predicate = predicate
        
        do {
            // Mengambil data dari Core Data dengan filter berdasarkan judul
            let result = try context.fetch(request) as! [NSManagedObject]
            
            // Memetakan hasil fetch ke array data filteredBooks
            for r in result {
                if let judul = r.value(forKey: "judul") as? String,
                   let price = r.value(forKey: "price") as? Double,
                   let imageData = r.value(forKey: "image") as? Data,
                   let image = UIImage(data: imageData),
                   let about = r.value(forKey:"about") as? String,
                   let author = r.value(forKey: "author") as? String,
                   let genre = r.value(forKey: "genre") as? String,
                   let image_author_data = r.value(forKey: "image_author") as? Data,
                   let image_author = UIImage(data: image_author_data),
                   let language = r.value(forKey: "language") as? String,
                   let overview = r.value(forKey: "overview") as? String,
                   let page = r.value(forKey: "page") as? Int,
                   let publisher = r.value(forKey: "publisher") as? String{
                    let data = detailBook(about: about,author: author,genre: genre,image: image,image_author: image_author,judul: judul, language: language, overview: overview, page: page, price: price, publisher: publisher)
                    listDetailBook.append(data)
                }
            }
            
        } catch {
            print("Gagal memuat data: \(error.localizedDescription)")
        }
    }
    
    func updateBook(newJudul: String, author: String, price: Double, genre: String, about: String, language: String, overview: String, page: Int, publisher: String, image: UIImage, imageAuthor: UIImage, username: String, from viewController: UIViewController, judul: String) {
        
        // Konversi gambar menjadi data (JPEG atau PNG)
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        guard let imageDataAuthor = imageAuthor.jpegData(compressionQuality: 1.0) else { return }
        
        // Mendapatkan context dari Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Mendapatkan entitas Catalog dari Core Data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalog")
        
        // Membuat NSPredicate untuk mencari data dengan kondisi tertentu
        let predicate = NSPredicate(format: "judul CONTAINS[cd] %@ AND username == %@", judul, username)
        request.predicate = predicate
        
        do {
            // Mengambil data yang sesuai dengan fetch request
            let result = try context.fetch(request)
            
            // Mengecek apakah ada data yang ditemukan
            if let resultArray = result as? [NSManagedObject], let bookToUpdate = resultArray.first {
                // Memperbarui nilai-nilai atribut yang diinginkan
                bookToUpdate.setValue(newJudul, forKey: "judul")
                bookToUpdate.setValue(author, forKey: "author")
                bookToUpdate.setValue(price, forKey: "price")
                bookToUpdate.setValue(genre, forKey: "genre")
                bookToUpdate.setValue(about, forKey: "about")
                bookToUpdate.setValue(language, forKey: "language")
                bookToUpdate.setValue(overview, forKey: "overview")
                bookToUpdate.setValue(page, forKey: "page")
                bookToUpdate.setValue(publisher, forKey: "publisher")
                
                // Menyimpan gambar baru
                bookToUpdate.setValue(imageData, forKey: "image")
                bookToUpdate.setValue(imageDataAuthor, forKey: "image_author")
                
                // Menyimpan perubahan ke dalam context
                try context.save()
                
                print("Data berhasil diperbarui!")
                self.showAlertSuccessfullUpdate(from: viewController)
            } else {
                print("Buku dengan judul \(judul) tidak ditemukan!")
            }
            
        } catch {
            print("Gagal memperbarui data: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func showAlertSuccessfull(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Successfully added", message: "Data successfully added", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    func showAlertSuccessfullUpdate(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Successfully Updated", message: "Data successfully updated", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}


