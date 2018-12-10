//
//  SnapLikeDataSource.swift
//  SnapLikeCollectionView
//
//  Created by Kei Fujikawa on 2018/12/03.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit

public protocol SnapLikeDataDelegate: class {
    func cellSelected(_ index: Int)
}

public class SnapLikeDataSource<Cell: UICollectionViewCell>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource where Cell: SnapLikeCell {
    
    enum NearestPointDirection: Int {
        case any
        case left
        case right
    }
    private var scrollVelocity: CGFloat = 0.0
    private var selectedItem: Int = 0
    
    public weak var delegate: SnapLikeDataDelegate?
    public var items: [Cell.Item] = []
    
    private let selectionFB = UISelectionFeedbackGenerator()
    
    private weak var collectionView: UICollectionView?
    private var collectionViewCenter: CGFloat
    private let cellSize: SnapLikeCellSize
    
    public init(collectionView: UICollectionView, cellSize: SnapLikeCellSize) {
        self.collectionView = collectionView
        self.collectionViewCenter = collectionView.bounds.width / 2
        self.cellSize = cellSize
    }
    
    // MARK: - Animation:
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.selectedItem == Int.max { return }
        
        let previousSelectedIndex: Int = selectedItem
        // add a placeholder value for selectedItem while scrolling
        selectedItem = Int.max
        
        reloadCell(at: IndexPath(item: previousSelectedIndex, section: 0), withSelectedState: false)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollVelocity = velocity.x
        
        if scrollVelocity == 0 {
            targetContentOffset.pointee = offset(forCenterX: targetContentOffset.pointee.x + collectionViewCenter, with: .any)
        }
        if scrollVelocity < 0 {
            targetContentOffset.pointee = offset(forCenterX: targetContentOffset.pointee.x + collectionViewCenter, with: .left)
        } else if scrollVelocity > 0 {
            targetContentOffset.pointee = offset(forCenterX: targetContentOffset.pointee.x + collectionViewCenter, with: .right)
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadCell(at: IndexPath(item: selectedItem, section: 0), withSelectedState: true)
        selectionFB.selectionChanged()
        delegate?.cellSelected(selectedItem)
    }
    
    /// Reload cell so it becomes selected or unselected
    public func reloadCell(at indexPath: IndexPath, withSelectedState selected: Bool) {
        if let cell = collectionView?.cellForItem(at: indexPath) {
            cell.isSelected = selected
        }
    }
    
    public func selectItem(_ indexPath: IndexPath) {
        perform(#selector(collectionView(_:didSelectItemAt:)),
                with: collectionView,
                with: indexPath)
    }
    
    // Calculate the offset to the center from the nearest cell
    func offset(forCenterX centerX: CGFloat, with direction: NearestPointDirection) -> CGPoint {
        let leftNearestCenters = nearestLeftCenter(forCenterX: centerX)
        let leftCenterIndex: Int = leftNearestCenters.index
        let leftCenter: CGFloat = leftNearestCenters.value
        let rightNearestCenters = nearestRightCenter(forCenterX: centerX)
        let rightCenterIndex: Int = rightNearestCenters.index
        let rightCenter: CGFloat = rightNearestCenters.value
        var nearestItemIndex: Int = Int.max
        switch direction {
        case .any:
            if leftCenter > rightCenter {
                nearestItemIndex = rightCenterIndex
            } else {
                nearestItemIndex = leftCenterIndex
            }
        case .left:
            nearestItemIndex = leftCenterIndex
        case .right:
            nearestItemIndex = rightCenterIndex
        }
        selectedItem = nearestItemIndex
        return CGPoint(x: CGFloat(nearestItemIndex) * cellSize.normalWidth, y: 0.0)
    }
    
    /// Getting the nearest cell attributes on the left
    func nearestLeftCenter(forCenterX centerX: CGFloat) -> (index: Int, value: CGFloat) {
        let nearestLeftElementIndex: CGFloat = (centerX - collectionViewCenter - cellSize.centerWidth + cellSize.normalWidth) / cellSize.normalWidth
        let minimumLeftDistance: CGFloat = centerX - nearestLeftElementIndex * cellSize.normalWidth - collectionViewCenter - cellSize.centerWidth + cellSize.normalWidth
        return (Int(nearestLeftElementIndex), minimumLeftDistance)
    }
    
    /// Getting the nearest cell attributes on the right
    func nearestRightCenter(forCenterX centerX: CGFloat) -> (index: Int, value: CGFloat) {
        let nearestRightElementIndex: Int = Int(ceilf(Float((centerX - collectionViewCenter - cellSize.centerWidth + cellSize.normalWidth) / cellSize.normalWidth)))
        let minimumRightDistance: CGFloat = CGFloat(nearestRightElementIndex) * cellSize.normalWidth + collectionViewCenter - centerX - cellSize.centerWidth + cellSize.normalWidth
        return (nearestRightElementIndex, minimumRightDistance)
    }
    
    // MARK : - Delegate
    
    @objc public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        scrollViewWillBeginDragging(collectionView)
        selectedItem = indexPath.item
        
        let layout = collectionView.collectionViewLayout as! SnapLikeCollectionViewFlowLayout
        let x: CGFloat = CGFloat(selectedItem) * cellSize.normalWidth
        layout.ignoringBoundsChange = true
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        layout.ignoringBoundsChange = false
        
        perform(#selector(self.scrollViewDidEndDecelerating), with: collectionView, afterDelay: 0.3)
    }
    
    // MARK : - DataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        cell.item = items[indexPath.item]
        return cell
    }
    
}
