//
//  BusesTable+CoreDataProperties.swift
//  GESolution
//
//  Created by Dejan Matejevic on 10/25/16.
//  Copyright © 2016 Dejan Matejevic. All rights reserved.
//

import Foundation
import CoreData


extension BusesTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusesTable> {
        return NSFetchRequest<BusesTable>(entityName: "BusesTable");
    }

    @NSManaged public var arrival: String?
    @NSManaged public var departure: String?
    @NSManaged public var iD: Int16
    @NSManaged public var logo: String?
    @NSManaged public var price: Double
    @NSManaged public var stops: Int16

}
