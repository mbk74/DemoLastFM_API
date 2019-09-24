//
//  ArtistViewCell.swift
//  AfLastFM
//
//  Created by Max Kolesnik on 9/22/19.
//  Copyright © 2019 Max Kolesnik. All rights reserved.
//

import UIKit

class ArtistViewCell: UITableViewCell {
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistPhoto: UIImageView!
    
    private var artistInfo: ArtistInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configure(with model: ArtistInfo) {
        artistInfo = model
        if let imageUrl = model.image.large {
            artistPhoto.af_setImage(withURL: imageUrl)
        }
        artistName.text = model.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
