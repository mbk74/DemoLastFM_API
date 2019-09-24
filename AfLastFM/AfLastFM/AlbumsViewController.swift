//
//  AlbumsViewController.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/15/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class AlbumsViewController: UITableViewController {
    var artist: ArtistInfo?
    var albums = [TopAlbumInfo]()
    var savedAlbumIds = Set<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = artist?.name
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        if let realm = try? Realm() {
            savedAlbumIds = Set(realm.objects(FullAlbumInfoObject.self).map { $0.uid })
        }
        
        guard let artistName = artist?.name else {
            return
        }
        let parameters = [
            "method": "artist.gettopalbums",
            "artist": artistName,
            "api_key": Configuration.apiKey,
            "format":  Configuration.format
        ]
        request("https://ws.audioscrobbler.com/2.0", parameters: parameters).responseData { response in
            if let data = response.data, let albumSearch = try? JSONDecoder().decode(TopAlbumInfoList.self, from: data) {
                self.albums = albumSearch.albums
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.name
        if savedAlbumIds.contains(album.hashValue) {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArtistAlbumDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let album = albums[indexPath.row]
                if let controller = segue.destination as? DetailPageViewController {
                    let parameters = [
                        "method": "album.getinfo",
                        "artist": album.artist,
                        "album": album.name,
                        "api_key": Configuration.apiKey,
                        "format":  Configuration.format
                    ]
                    request("https://ws.audioscrobbler.com/2.0", parameters: parameters).responseData { response in
                        if let data = response.data, let albumDetails = try? JSONDecoder().decode(FullAlbumInfo.self, from: data) {
                            DispatchQueue.main.async {
                                controller.detailItem = albumDetails
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
