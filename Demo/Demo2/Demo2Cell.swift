//
//  Demo2Cell.swift
//  Demo
//
//  Created by Kei Fujikawa on 2018/12/10.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit
import SnapLikeCollectionView

class Demo2Cell: UICollectionViewCell, SnapLikeCell {
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 32
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: String? {
        didSet {
            titleLabel.text = item
        }
    }
}
