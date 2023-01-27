//
//  AllClassesTableViewCell.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 6/12/2564 BE.
//

import UIKit

class AllClassesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var imgClass: UIImageView!
    @IBOutlet weak var txtClass: UILabel!
    @IBOutlet weak var txtTrainer: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
