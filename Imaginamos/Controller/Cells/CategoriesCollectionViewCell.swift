//
//  CollectionCell.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.alpha = 0.0
    }
    
}
