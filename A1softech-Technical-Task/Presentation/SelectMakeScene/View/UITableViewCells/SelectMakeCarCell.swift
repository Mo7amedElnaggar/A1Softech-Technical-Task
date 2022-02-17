//
//  SelectMakeCarCell.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/14/22.
//

import UIKit

class SelectMakeCarCell: UITableViewCell {
    
    @IBOutlet weak var carMakeNameLbl: UILabel!
    
    var vehicle: Vehicle? {
        didSet {
            self.carMakeNameLbl?.text = vehicle?.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
