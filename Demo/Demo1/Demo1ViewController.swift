//
//  ViewController.swift
//  Demo
//
//  Created by Kei Fujikawa on 2018/12/03.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit
import SnapLikeCollectionView

class Demo1ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: SnapLikeDataSource<Demo1Cell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let cellSize = SnapLikeCellSize(normal: 100, center: 160)
        dataSource = SnapLikeDataSource<Demo1Cell>(collectionView: collectionView, cellSize: cellSize)
        dataSource?.delegate = self
        
        let layout = SnapLikeCollectionViewFlowLayout(cellSize: cellSize)
        collectionView.collectionViewLayout = layout
        
        collectionView.registerNib(Demo1Cell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        
        dataSource?.items = ["A", "B", "C", "D", "E"]
    }
}

extension Demo1ViewController: SnapLikeDataDelegate {
    func cellSelected(_ index: Int) {
        DispatchQueue.main.async { [weak self] in
            let selectedItem: String = self?.dataSource?.items[index] ?? ""
            self?.titleLabel.text = selectedItem
        }
    }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_ cellType: T.Type){
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
}

