//
//  PromotionsCell.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 22.06.2023.
//

import UIKit
import AlamofireImage

final class PromotionsCell: UICollectionViewCell {
    @IBOutlet private var promotionImage: UIImageView!
    
    func setup(url: String) {
        promotionImage.af.setImage(withURL: URL(string: url)!)
    }
}
