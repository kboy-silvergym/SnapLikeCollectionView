//
//  SnapLikeCell.swift
//  SnapLikeCollectionView
//
//  Created by Kei Fujikawa on 2018/12/03.
//  Copyright © 2018 kboy. All rights reserved.
//

public protocol SnapLikeCell: class {
    associatedtype Item
    var item: Item? { get set }
}
