//
//  FlightsTable+CoreDataProperties.swift
//  GESolution
//
//  Created by Dejan Matejevic on 10/25/16.
//  Copyright © 2016 Dejan Matejevic. All rights reserved.
//

import Foundation
import CoreData


extension FlightsTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightsTable> {
        return NSFetchRequest<FlightsTable>(entityName: "FlightsTable");
    }

    @NSManaged public var arrival: String?
    @NSManaged public var departure: String?
    @NSManaged public var iD: Int16
    @NSManaged public var logo: String?
    @NSManaged public var price: Double
    @NSManaged public var stops: Int16

}
