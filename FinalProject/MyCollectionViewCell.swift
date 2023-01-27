//
//  MyCollectionViewCell.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 5/12/2564 BE.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textViewBlock: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var dateViewBlock: UIView!
    @IBOutlet weak var txtMonth: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    
    var yt: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

