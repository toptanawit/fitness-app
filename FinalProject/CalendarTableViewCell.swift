//
//  CalendarTableViewCell.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 6/12/2564 BE.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var imgClass: UIImageView!
    @IBOutlet weak var lbClass: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewBlock: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
