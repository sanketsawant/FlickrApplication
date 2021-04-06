//
//  FlickImageCollectionViewCell.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 03/04/2021.
//

import UIKit
import Alamofire
import AlamofireImage

class FlickImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(with photo:Photo, placeholderImage:UIImage) -> Void {
        guard let flickURL = photo.flickrImageURL else {
            imageView.image = placeholderImage
            return
        }
        imageView.af.setImage(withURL: flickURL, placeholderImage: placeholderImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
