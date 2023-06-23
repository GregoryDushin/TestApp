//
//  HeaderCell.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 22.06.2023.
//

import UIKit

final class HeaderCell: UICollectionViewCell {
    
    @IBOutlet private var headerLabel: UILabel!
    
    func setup(title: String) {
        headerLabel.text = title
    }
}
