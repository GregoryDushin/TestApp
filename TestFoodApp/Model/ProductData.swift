//
//  ProductData.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import Foundation

struct Section: Hashable {
    let sectionType: SectionType
    let items: [ListItem]
}

enum SectionType {
    case horizontalPromo
    case horizontalButton
}

enum ListItem: Hashable {
    case horizontalPromoInfo(url: String)
    case horizontalButtonInfo(categorie: String)
}
