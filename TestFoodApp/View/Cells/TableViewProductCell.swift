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
    @IBOutlet private var heightLabel: UILabel!
    @IBOutlet private var diameterLabel: UILabel!
    @IBOutlet private var massLabel: UILabel!

    func setup (
        url: String,
        name: String,
        description: String,
        price: String,
        height: String,
        diameter: String,
        weight: String
    ) {
        if let imageURL = URL(string: url) {
            productImage.af.setImage(withURL: imageURL)
        }
        nameProduct.text = name
        descriptionProductLabel.text = description
        priceProductLabel.text = price
        heightLabel.text = height
        diameterLabel.text = diameter
        massLabel.text = weight
    }
}
