//
//  BookDetails+CoreDataProperties.swift
//  Gramejia
//
//  Created by fits on 01/12/24.
//
//

import Foundation
import CoreData


extension BookDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookDetails> {
        return NSFetchRequest<BookDetails>(entityName: "BookDetails")
    }

    @NSManaged public var judul: String?
    @NSManaged public var author: String?
    @NSManaged public var price: Double
    @NSManaged public var image: Data?

}

extension BookDetails : Identifiable {

}
