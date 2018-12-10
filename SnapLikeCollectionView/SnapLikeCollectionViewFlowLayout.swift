//
//  SnapLikeCollectionViewFlowLayout.swift
//  SnapLikeCollectionView
//
//  Created by Kei Fujikawa on 2018/12/03.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit

public class SnapLikeCollectionViewFlowLayout: UICollectionViewFlowLayout {
    /// Used to ignore bounds change when auto scrolling to certain cell
    var ignoringBoundsChange: Bool = false
    
    private var centerOffset: CGFloat {
        return (collectionView!.bounds.width - cellSize.centerWidth) / 2
    }
    private var height: CGFloat {
        return collectionView!.bounds.height
    }
    private var numberOfItems: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    /// Dragging offset (used to calculate which cell is selected)
    private lazy var dragOffset: CGFloat = cellSize.normalWidth
    private var cache = [UICollectionViewLayoutAttributes]()
    private let cellSize: SnapLikeCellSize
    
    public init(cellSize: SnapLikeCellSize){
        self.cellSize = cellSize
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayout(forBounds newBounds: CGRect) {
        let deltaX: CGFloat = cellSize.centerWidth - cellSize.normalWidth
        let deltaY: CGFloat = cellSize.centerHeight - cellSize.normalHeight
        let leftSideInset: CGFloat = (newBounds.width - cellSize.centerWidth) / 2
        
        for attribute in cache {
            let normalCellOffsetX: CGFloat = leftSideInset + CGFloat(attribute.indexPath.row) * cellSize.normalWidth
            let normalCellOffsetY: CGFloat = (newBounds.height - cellSize.normalHeight) / 2
            
            let distanceBetweenCellAndBoundCenters = normalCellOffsetX - newBounds.midX + cellSize.centerWidth / 2
            
            let normalizedCenterScale = distanceBetweenCellAndBoundCenters / cellSize.normalWidth
            
            let isCenterCell: Bool = fabsf(Float(normalizedCenterScale)) < 1.0
            let isNormalCellOnRightOfCenter: Bool = normalizedCenterScale > 0.0 && !isCenterCell
            let isNormalCellOnLeftOfCenter: Bool = normalizedCenterScale < 0.0 && !isCenterCell
            
            if isCenterCell {
                let incrementX: CGFloat = (1.0 - CGFloat(abs(Float(normalizedCenterScale)))) * deltaX
                let incrementY: CGFloat = (1.0 - CGFloat(abs(Float(normalizedCenterScale)))) * deltaY
                
                let offsetX: CGFloat = normalizedCenterScale > 0 ? deltaX - incrementX : 0
                let offsetY: CGFloat = -incrementY / 2
                
                attribute.frame = CGRect(
                    x: normalCellOffsetX + offsetX,
                    y: normalCellOffsetY + offsetY,
                    width: cellSize.normalWidth + incrementX,
                    height: cellSize.normalHeight + incrementY
                )
            } else if isNormalCellOnRightOfCenter {
                attribute.frame = CGRect(
                    x: normalCellOffsetX + deltaX,
                    y: normalCellOffsetY,
                    width: cellSize.normalWidth,
                    height: cellSize.normalHeight
                )
            } else if isNormalCellOnLeftOfCenter {
                attribute.frame = CGRect(
                    x: normalCellOffsetX,
                    y: normalCellOffsetY,
                    width: cellSize.normalWidth,
                    height: cellSize.normalHeight
                )
            }
        }
        
    }
}

// MARK: - UICollectionViewFlowLayout
extension SnapLikeCollectionViewFlowLayout {
    
    /// Return the size of all the content in the collection view
    override public var collectionViewContentSize: CGSize {
        let contentWidth: CGFloat = 2 * centerOffset + cellSize.centerWidth + CGFloat(numberOfItems - 1) * cellSize.normalWidth
        return CGSize(width: contentWidth, height: height)
    }
    
    override public func prepare() {
        if cache.isEmpty || cache.count != numberOfItems {
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                cache.append(attributes)
            }
            updateLayout(forBounds: (collectionView?.bounds)!)
        }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        updateLayout(forBounds: newBounds)
        return !ignoringBoundsChange
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.x / dragOffset)
        let xOffset = itemIndex * dragOffset
        return CGPoint(x: xOffset, y: 0)
    }
}
