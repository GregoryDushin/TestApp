//
//  RocketModel.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import Foundation

// MARK: - CodableRocketModel

struct RocketModelElement: Decodable, Equatable {
    let height: Diameter
    let diameter: Diameter
    let mass: Mass
    let flickrImages: [String]
    let name: String
    let costPerLaunch: Int
}

// MARK: - Diameter

extension RocketModelElement {
    struct Diameter: Decodable, Equatable {
        let meters: Double?
        let feet: Double?
    }

// MARK: - Mass

    struct Mass: Decodable, Equatable {
        let kg: Int
        let lb: Int
    }

// MARK: - PayloadWeight

    struct PayloadWeight: Decodable, Equatable {
        let kg: Int
        let lb: Int
    }
}
