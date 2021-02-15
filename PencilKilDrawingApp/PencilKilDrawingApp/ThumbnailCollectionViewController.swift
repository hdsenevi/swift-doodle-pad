//
//  ThumbnailCollectionViewController.swift
//  PencilKilDrawingApp
//
//  Created by Shanaka Senevirathne on 15/2/21.
//

import UIKit
import PencilKit

class ThumbnailCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sketchDataSource = SketchDataSource()
    private let reuseIdentifier = "ThumbnailCell"
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    private var thumbnailSize: CGSize?
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sketchDataSource.observers.append(self)
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addDrawing(_:)))
        let width = (view.frame.size.width - (sectionInsets.left * 2 + 20.0)) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width * 4 / 3)
        thumbnailSize = layout.itemSize
    }
    
    @objc
    func addDrawing(_ sender: UIBarButtonItem) {
        sketchDataSource.addDrawing()
        collectionView.reloadData()
    }
}

extension ThumbnailCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sketchDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SketchCell
        cell.backgroundColor = UIColor.lightGray
        
        cell.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        if let thumbnailImage = sketchDataSource.sketches[indexPath.row].thumbnailImage {
            cell.image = thumbnailImage
        }
        
        return cell
    }
}

extension ThumbnailCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        guard let drawingViewController = storyboard?.instantiateViewController(identifier: "DrawingViewController") as? DrawingViewController,
              let navigationController = navigationController else {
            return
        }
        drawingViewController.sketch = sketchDataSource.sketches[indexPath.row]
        drawingViewController.sketchDataSource = sketchDataSource
        navigationController.pushViewController(drawingViewController, animated: true)
    }
}

extension ThumbnailCollectionViewController: SketchDataSourceObserver {
    func thumbnailDidUpdate(_ thumbnail: UIImage) {
        collectionView.reloadData()
    }
}
