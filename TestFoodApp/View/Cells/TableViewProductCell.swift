//
//  TableViewProductCell.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import UIKit

final class TableViewProductCell: UITableViewCell {

    @IBOutlet private var productImage: UIImageView!
    @IBOutlet private var nameProduct: UILabel!
    @IBOutlet private var descriptionProductLabel: UILabel!
    @IBOutlet private var priceProductLabel: UILabel!
    
    func setup (url: String, name: String, description: String, price: String) {
        productImage.af.setImage(withURL: URL(string: url)!)
        nameProduct.text = name
        descriptionProductLabel.text = description
        priceProductLabel.text = price
    }
}
