import UIKit
import CoreData

class CreateUserData {
    
    // Pastikan context sudah tersedia
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
    
    func addUser(email: String, username: String, password: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        // Set nilai atribut untuk user
        newUser.setValue(username, forKey: "username")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(password, forKey: "password")
        
        // Simpan perubahan ke Core Data
        do {
            try context.save()
            addBalance(username: username)
            print("User successfully saved to Core Data")
        } catch let error as NSError {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    func addBalance(username: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Balance", in: context)
        
        let newBalance = NSManagedObject(entity: entity!, insertInto: context)
        
        // Set nilai atribut untuk user
        newBalance.setValue(username, forKey: "user")
        newBalance.setValue(0, forKey: "money")
        
        // Simpan perubahan ke Core Data
        do {
            try context.save()
            print("User successfully saved to Core Data")
        } catch let error as NSError {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    func checkIfUsernameExists(username: String) -> Bool {
            // Buat request untuk mengambil data dari entitas "User"
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
            
            // Tentukan predicate untuk mencari user berdasarkan username
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            
            do {
                // Coba ambil data dari Core Data
                let result = try context.fetch(fetchRequest)
                
                // Jika hasilnya lebih dari 0, berarti username sudah ada
                if result.count > 0 {
                    print("Username \(username) already exists.")
                    return true
                } else {
                    print("Username \(username) is available.")
                    return false
                }
            } catch let error as NSError {
                print("Failed to fetch data: \(error.localizedDescription)")
                return false
            }
        }
    
    // Fungsi untuk memeriksa apakah password sesuai dengan username yang dimasukkan
        func checkPasswordForUsername(username: String, password: String) -> Bool {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username == %@", username)
            
            do {
                let result = try context.fetch(fetchRequest)
                
                // Jika ditemukan username yang sesuai
                if let user = result.first as? NSManagedObject,
                   let storedPassword = user.value(forKey: "password") as? String {
                    // Bandingkan password yang dimasukkan dengan password yang tersimpan
                    if storedPassword == password {
                        return true
                    } else {
                        print("Password does not match.")
                        return false
                    }
                } else {
                    print("User not found.")
                    return false
                }
            } catch let error as NSError {
                print("Failed to fetch data: \(error.localizedDescription)")
                return false
            }
        }
    
    func getEmailForUsername(username: String) -> String? {
        // Buat request untuk mengambil data dari entitas "User"
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        
        // Tentukan predicate untuk mencari user berdasarkan username
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            // Coba ambil data dari Core Data
            let result = try context.fetch(fetchRequest)
            
            // Jika ada hasil dan username ditemukan
            if let user = result.first as? NSManagedObject,
               let email = user.value(forKey: "email") as? String {
                return email
            } else {
                print("User not found.")
                return nil
            }
        } catch let error as NSError {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getBalanceForUsername(username: String) -> Double? {
            // Buat request untuk mengambil data dari entitas "Balance"
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Balance")
            
            // Tentukan predicate untuk mencari balance berdasarkan username
            fetchRequest.predicate = NSPredicate(format: "user == %@", username)
            
            do {
                // Coba ambil data dari Core Data
                let result = try context.fetch(fetchRequest)
                
                // Jika ada hasil dan username ditemukan
                if let balanceEntity = result.first as? NSManagedObject,
                   let balance = balanceEntity.value(forKey: "money") as? Double {
                    return balance
                } else {
                    print("Balance not found for username \(username).")
                    return nil
                }
            } catch let error as NSError {
                print("Failed to fetch data: \(error.localizedDescription)")
                return nil
            }
        }
    
    func updateBalanceForUsername(username: String, newBalance: Double) -> Bool {
        // Buat request untuk mengambil data dari entitas "Balance"
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Balance")
        
        // Tentukan predicate untuk mencari balance berdasarkan username
        fetchRequest.predicate = NSPredicate(format: "user == %@", username)
        
        do {
            // Coba ambil data dari Core Data
            let result = try context.fetch(fetchRequest)
            
            // Jika ada hasil dan username ditemukan
            if let balanceEntity = result.first as? NSManagedObject {
                // Ambil saldo yang sudah ada sebelumnya
                if let currentBalance = balanceEntity.value(forKey: "money") as? Double {
                    // Jumlahkan saldo lama dengan saldo baru yang diinputkan oleh pengguna
                    let updatedBalance = currentBalance + newBalance
                    
                    // Set nilai baru untuk "money"
                    balanceEntity.setValue(updatedBalance, forKey: "money")
                    
                    // Simpan perubahan ke Core Data
                    try context.save()
                    print("Balance for username \(username) updated to \(updatedBalance)")
                    
                    return true // Pembaruan berhasil
                } else {
                    print("Current balance not found for username \(username).")
                    return false // Tidak dapat menemukan saldo yang ada
                }
            } else {
                print("Balance not found for username \(username).")
                return false // Entitas balance tidak ditemukan
            }
        } catch let error as NSError {
            print("Failed to update balance: \(error.localizedDescription)")
            return false // Terjadi error saat fetch atau save
        }
    }




}
