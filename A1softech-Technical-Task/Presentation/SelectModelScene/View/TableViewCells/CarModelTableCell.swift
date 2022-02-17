//
//  CarModelTableCell.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/16/22.
//

import UIKit
import SDWebImage

class CarModelTableCell: UITableViewCell {

    @IBOutlet weak var carModelImageView: UIImageView!
    @IBOutlet weak var carModelNameLbl: UILabel!
    @IBOutlet weak var loadingView: LoadingView!
    
    var model: CarModel? {
        didSet {
            carModelNameLbl?.text = model?.name
            guard let image = model?.photoUrl else { return }
            self.loadingView.isLoading = true
            carModelImageView.sd_setImage(with: URL(string: image)) { [weak self] (image, error, type, url) in
                self?.loadingView.isLoading = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
