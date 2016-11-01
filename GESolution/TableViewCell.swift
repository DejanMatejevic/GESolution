//
//  TableViewCell.swift
//  GESolution
//
//  Created by Dejan Matejevic on 10/22/16.
//  Copyright © 2016 Dejan Matejevic. All rights reserved.
//

import Foundation
import UIKit


class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var BuyTicket: UIButton!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var StartEndTimeTravel: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var NumberOfStations: UILabel!
    @IBOutlet weak var TravelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
}
