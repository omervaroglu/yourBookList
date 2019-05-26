//
//  CustomCellView.swift
//  yourBookList
//
//  Created by Ömer Varoğlu on 24.05.2019.
//  Copyright © 2019 Omer Varoglu. All rights reserved.
//

import UIKit

class CustomCellView: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
       cellView.layer.cornerRadius = 10.0
       cellView.layer.shadowColor = UIColor.black.cgColor
       cellView.layer.shadowOffset = CGSize(width: 0, height: 1)
       cellView.layer.shadowOpacity = 0.2
       cellView.layer.shadowRadius = 5
       cellView.layer.borderWidth = 2
       cellView.layer.borderColor = UIColor.orange.cgColor
    }
}
