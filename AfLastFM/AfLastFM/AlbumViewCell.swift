//
//  AlbumViewCell.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AlbumViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    private var albumInfo: SimpleAlbumInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configure(with model: SimpleAlbumInfo) {
        albumInfo = model
        if let imageUrl = model.imageUrl {
            albumImage.af_setImage(withURL: imageUrl)
        }
        albumName.text = model.albumTitle
        albumArtist.text = model.albumArtist
    }
}

