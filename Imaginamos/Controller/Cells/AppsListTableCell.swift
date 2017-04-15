//
//  AppsListTableCell.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/13/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit

class AppsListTableCell: UITableViewCell {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.alpha = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
