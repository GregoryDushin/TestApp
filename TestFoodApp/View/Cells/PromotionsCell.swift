//
//  PromotionsCell.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import AlamofireImage
import UIKit

final class PromotionsCell: UICollectionViewCell {

    @IBOutlet private var promotionImage: UIImageView!

    func setup(url: String) {
        if let imageURL = URL(string: url) {
            promotionImage.af.setImage(withURL: imageURL)
        }
    }
}
