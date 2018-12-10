//
//  UICollectionView+Extensions.swift
//  Demo
//
//  Created by Kei Fujikawa on 2018/12/10.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_ cellType: T.Type){
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
}
