//
//  MainScreenViewController.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/15/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

class MainScreenViewController: UICollectionViewController {
    
    private let reuseIdentifier = "AlbumCell"
    
    var albums = [SimpleAlbumInfo]()
    
    let columnLayout = ColumnFlowLayout(
         cellsPerRow: 2,
         minimumInteritemSpacing: 10,
         minimumLineSpacing: 10,
         sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
     )

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib.init(nibName: "AlbumViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        if let realm = try? Realm() {
            albums = realm.objects(FullAlbumInfoObject.self).map { $0 as SimpleAlbumInfo}
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumViewCell
        let album = albums[indexPath.row]
        cell.configure(with: album)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumDetail" {
            if let indexPath = sender as? IndexPath {
                let album = albums[indexPath.row]
                if let controller = segue.destination as? DetailPageViewController {
                    controller.viewMode = .delete
                    controller.detailItem = album
                }
            }
        }
    }

    // MARK: UICollectionViewDelegate
    
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
     }
    
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        performSegue(withIdentifier: "showAlbumDetail", sender: indexPath)
        return true
     }
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
    */
}
