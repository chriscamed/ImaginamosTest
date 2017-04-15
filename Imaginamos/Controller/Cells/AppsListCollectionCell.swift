//
//  AppsListCollectionCell.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/13/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit

class AppsListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var appImg: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.alpha = 0.0
    }
    
    
    override func awakeFromNib() {
        appTitle.alpha = 0.0
        appImg.alpha = 0.0
        blurEffectView.alpha = 0.0
    }
    
    
}
