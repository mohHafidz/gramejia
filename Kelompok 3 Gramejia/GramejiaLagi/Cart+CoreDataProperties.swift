//
//  Cart+CoreDataProperties.swift
//  Gramejia
//
//  Created by fits on 01/12/24.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var username: String?
    @NSManaged public var judul: String?
    @NSManaged public var quantity: Int32

}

extension Cart : Identifiable {

}
