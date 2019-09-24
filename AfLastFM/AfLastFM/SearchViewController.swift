//
//  SearchViewController.swift
//  
//
//  Created by Max Kolesnik on 9/22/19.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSearch: UITableView!
    
    var artists = [ArtistInfo]()
    
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSearch.dataSource = self
        self.tblSearch.delegate = self
        self.searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showArtistDetail" {
               if let indexPath = tblSearch.indexPathForSelectedRow {
                   let artist = artists[indexPath.row]
                   if let controller = segue.destination as? AlbumsViewController {
                       controller.artist = artist
                   }
               }
           }
       }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = artists[indexPath.row].name
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearch = false;
            artists.removeAll()
            self.tblSearch.reloadData()
        } else {
            let parameters = [
                "method": "artist.search",
                "artist": searchText,
                "api_key": Configuration.apiKey,
                "format": Configuration.format
            ]
            request("https://ws.audioscrobbler.com/2.0", parameters: parameters).responseData { response in
                if let data = response.data, let artistSearch = try? JSONDecoder().decode(ArtistSearchResponse.self, from: data) {
                    self.artists = artistSearch.artistInfos
                    DispatchQueue.main.async { [weak self] in
                        self?.tblSearch.reloadData()
                    }
                }
            }
        }
    }

}
