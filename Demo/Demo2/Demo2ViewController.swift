//
//  Demo2ViewController.swift
//  Demo
//
//  Created by Kei Fujikawa on 2018/12/10.
//  Copyright © 2018 kboy. All rights reserved.
//


import UIKit
import SnapLikeCollectionView

class Demo2ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: SnapLikeDataSource<Demo2Cell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewHeiht: CGFloat = collectionView.frame.height
        let cellSize = SnapLikeCellSize(
            normalWidth: screenWidth / 3,
            centerWidth: screenWidth * 2 / 3,
            normalHeight: collectionViewHeiht / 3,
            centerHeight: collectionViewHeiht * 2 / 3
        )
        dataSource = SnapLikeDataSource<Demo2Cell>(collectionView: collectionView, cellSize: cellSize)
        dataSource?.delegate = self
        
        let layout = SnapLikeCollectionViewFlowLayout(cellSize: cellSize)
        collectionView.collectionViewLayout = layout
        
        collectionView.registerNib(Demo2Cell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        
        dataSource?.items = ["😎", "🤩", "😍", "😡", "🤫"]
    }
}

extension Demo2ViewController: SnapLikeDataDelegate {
    func cellSelected(_ index: Int) {
        
    }
}

