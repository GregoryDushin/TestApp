//
//  CategoriesCell.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import UIKit

final class CategoriesCell: UICollectionViewCell {

    @IBOutlet private var categoriesButton: UIButton!

    var buttonActionHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        categoriesButton.layer.masksToBounds = true
        categoriesButton.layer.cornerRadius = 10
        categoriesButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    func setup(categorie: String, rowIndex: Int) {
        self.tag = rowIndex
        categoriesButton.setTitle(categorie, for: .normal)
        let buttonColor: UIColor = self.tag == rowIndex ? .lightGray : .white
        setButtonColor(buttonColor)
    }

    func setButtonColor(_ color: UIColor) {
        categoriesButton.backgroundColor = color
    }

    @objc func buttonPressed() {
        buttonActionHandler?()
    }
}
