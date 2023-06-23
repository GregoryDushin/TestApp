//
//  RealmModel.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import RealmSwift

import RealmSwift

class RocketObject: Object {
    @objc dynamic var height: DiameterObject?
    @objc dynamic var diameter: DiameterObject?
    @objc dynamic var mass: MassObject?
    let flickrImages = List<String>()
    @objc dynamic var name: String = ""
    @objc dynamic var costPerLaunch: Int = 0

    convenience init(rocketModel: RocketModelElement) {
        self.init()
        self.height = DiameterObject(diameter: rocketModel.height)
        self.diameter = DiameterObject(diameter: rocketModel.diameter)
        self.mass = MassObject(mass: rocketModel.mass)
        self.flickrImages.append(objectsIn: rocketModel.flickrImages)
        self.name = rocketModel.name
        self.costPerLaunch = rocketModel.costPerLaunch
    }
}

class DiameterObject: Object {
    @objc dynamic var meters: Double = 0.0
    @objc dynamic var feet: Double = 0.0

    convenience init(diameter: RocketModelElement.Diameter) {
        self.init()
        self.meters = diameter.meters ?? 0.0
        self.feet = diameter.feet ?? 0.0
    }
}

class MassObject: Object {
    @objc dynamic var kg: Int = 0
    @objc dynamic var lb: Int = 0

    convenience init(mass: RocketModelElement.Mass) {
        self.init()
        self.kg = mass.kg
        self.lb = mass.lb
    }
}
