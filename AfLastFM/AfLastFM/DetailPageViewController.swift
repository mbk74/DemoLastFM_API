//
//  DetailPageViewController.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/15/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

enum DetailMode {
    case add
    case delete
}

class DetailPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var existMark: UIView!
    @IBOutlet weak var trackTable: UITableView!
    
    public var viewMode: DetailMode = .add
    
    private let child = SpinnerViewController()
    private let realm = try? Realm()
    
    var detailItem: SimpleAlbumInfo? {
        didSet {
            configureView()
            switch viewMode {
            case .add:
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                checkState()
                trackTable.reloadData()
            case .delete:
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeFromLibraryAndExit))
            }
        }
    }
    
    func checkState() {
        if let realm = realm {
            if realm.object(ofType: FullAlbumInfoObject.self, forPrimaryKey: detailItem?.uid) != nil {
                existMark.isHidden = false
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeFromLibrary))
            } else {
                existMark.isHidden = true
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToLibrary(_:)))
            }
        }
    }
    
    func configureView() {
        if let detail = detailItem {
            if let imageUrl = detail.imageUrl{
                albumImage?.af_setImage(withURL: imageUrl)
            }
            albumName?.text = detail.albumTitle
            albumArtist?.text = detail.albumArtist
        }
    }
    
    @objc func removeFromLibrary() {
        removeItem {
            DispatchQueue.main.async { [weak self] in
                self?.checkState()
            }
        }
    }
    
    @objc func removeFromLibraryAndExit() {
         removeItem {
            DispatchQueue.main.async { [weak self] in
                self?.existMark.isHidden = true
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func removeItem(completion: @escaping ()->()) {
        guard let albumObject = detailItem else { return }
        let alert = UIAlertController(title: "Remove album \'\(albumObject.albumTitle)\' from library?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            if let realm = self?.realm, let realmObject = realm.object(ofType: FullAlbumInfoObject.self, forPrimaryKey: albumObject.uid) {
                    try? realm.write {
                        realm.delete(realmObject)
                        completion()
                    }
                }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func addToLibrary(_ sender: Any) {
        if let realm = realm, let album = detailItem as? FullAlbumInfo {
            try? realm.write {
                let albumObject = FullAlbumInfoObject(album: album)
                realm.add(albumObject)
                self.checkState()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackTable.dataSource = self
        self.trackTable.delegate = self
        
        existMark.isHidden = viewMode == .add
        if viewMode == .add {
            createSpinnerView()
        } else {
            configureView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem?.tracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        if let trackName = detailItem?.tracks[indexPath.row] {
            cell.textLabel?.text = "\(indexPath.row + 1) \(trackName)"
        }
        return cell
    }
    
    func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

