//
//  CategoriesCell.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 22.06.2023.
//

import UIKit

final class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet private var categoriesButton: UIButton!
    
    var buttonActionHandler: (() -> Void)?
    
    override func awakeFromNib() {
            super.awakeFromNib()
            categoriesButton.layer.masksToBounds = true
            categoriesButton.layer.cornerRadius = 20
            categoriesButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
        
        func setup(categorie: String){
            categoriesButton.setTitle(categorie, for: .normal)
        }
        
        @objc func buttonPressed() {
            buttonActionHandler?()
        }
    }




