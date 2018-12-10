# 👻 SnapLikeCollectionView 👻 

![platform](https://img.shields.io/badge/platform-ios-blue.svg) ![ios](https://img.shields.io/badge/ios-11.0%2B-blue.svg) ![swift](https://img.shields.io/badge/swift-4.2-orange.svg) ![license](https://img.shields.io/badge/license-MIT-lightgrey.svg)
<a href="https://twitter.com/kboy_silvergym">![tw](https://img.shields.io/badge/twitter-%40kboy__silvergym-blue.svg)</a>

## About

The collectionView library which is scaling, scrolling and stopping comfortably like Snapchat and Instagram.

### Demo1

Comparison with Instagram and Snapchat.

|👻 This 👻|Instagram|Snapchat|
|:-:|:-:|:-:|
|<img src="Images/this.gif" width=200>|<img src="Images/instagram.gif" width=180>|<img src="Images/snapchat.gif" width=180>|

### Demo2

You can change cell height since ver. 1.1.0

<img src="Images/demo2.gif" width=200>


## Requirements
Swift 4.2. Ready for use on iOS 11.0+

## Installation

### via Cocoapods

```ruby
pod 'SnapLikeCollectionView'
```

## Usage

### Cell

You should use **SnapLikeCell** protocol.

**Item** is associatedtype. You can apply any model you want.

This **Item** becomes dataSource's items.

```swift
public protocol SnapLikeCell: class {
    associatedtype Item
    var item: Item? { get set }
}
```

Below is example.

```swift
import UIKit
import SnapLikeCollectionView

class SampleCell: UICollectionViewCell, SnapLikeCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: String? {
        didSet {
            titleLabel.text = item
        }
    }
}
```

### ViewController

```swift
import UIKit
import SnapLikeCollectionView

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // set your original Cell to <SampleCell>
    private var dataSource: SnapLikeDataSource<SampleCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup size of cells
        let cellSize = SnapLikeCellSize(normal: 100, center: 160)
        
        // create dataSource
        dataSource = SnapLikeDataSource<SampleCell>(collectionView: collectionView, cellSize: cellSize)
        dataSource?.delegate = self
        
        // create FlowLayout
        let layout = SnapLikeCollectionViewFlowLayout(cellSize: cellSize)
        collectionView.collectionViewLayout = layout
        
        // setup collectionView like this
        collectionView.registerNib(SampleCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        
        // pass arrays which type is decided `Item` in the SampleCell.
        dataSource?.items = ["A", "B", "C", "D", "E"]
    }
}

// listen selected listener
extension ViewController: SnapLikeDataDelegate {
    func cellSelected(_ index: Int) {
        DispatchQueue.main.async { [weak self] in
            let selectedItem: String = self?.dataSource?.items[index] ?? ""
            self?.titleLabel.text = selectedItem
        }
    }
}
```

Check how to use from [Demo](https://github.com/kboy-silvergym/SnapLikeCollectionView/tree/master/Demo) 👍👍

## Welcome to your PR
This library is not perfect, so welcome to your PR 🤲🤲🤲

## Author 👻

<img src ="https://avatars3.githubusercontent.com/u/17683316?s=460&v=4" width=150>

**KBOY (Kei Fujikawa)**

iOS Developer in Tokyo Japan, working on AR startup named [Graffity Inc.](https://www.graffity.jp/)

- [Twitter](https://twitter.com/kboy_silvergym) / [Facebook](https://www.facebook.com/kei.fujikawa1)
- [LinkedIn](https://www.linkedin.com/in/kei-fujikawa) / [Wantedly](https://www.wantedly.com/users/17820205)

## License

SnapLikeCollectionView is available under the MIT license. See the LICENSE file for more info.
