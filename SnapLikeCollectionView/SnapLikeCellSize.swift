//
//  SnapLikeCellSize.swift
//  SnapLikeCollectionView
//
//  Created by Kei Fujikawa on 2018/12/03.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit

public struct SnapLikeCellSize {
    let normalWidth: CGFloat
    let centerWidth: CGFloat
    let normalHeight: CGFloat
    let centerHeight: CGFloat
    
    public init(normalWidth: CGFloat,
                centerWidth: CGFloat,
                normalHeight: CGFloat? = nil,
                centerHeight: CGFloat? = nil) {
        self.normalWidth = normalWidth
        self.centerWidth = centerWidth
        self.normalHeight = normalHeight ?? normalWidth
        self.centerHeight = centerHeight ?? centerWidth
    }
}
