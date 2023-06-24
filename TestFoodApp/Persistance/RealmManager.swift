//
//  RealmManager.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import RealmSwift

protocol RealmManagerProtocol {
    func saveRockets(_ rockets: [RocketModelElement])
    func getSavedRockets() -> [RocketModelElement]
}

class RealmManager: RealmManagerProtocol {
    static let shared = RealmManager()
    private let realm: Realm

     init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func saveRockets(_ rockets: [RocketModelElement]) {
        let rocketObjects = rockets.map { createRocketObject(from: $0) }
        DispatchQueue.main.async { [self] in
            do {
                try self.realm.write {
                    self.realm.add(rocketObjects)
                }
            } catch {
                print("Failed to save rockets: \(error)")
            }
        }
    }

    func getSavedRockets() -> [RocketModelElement] {
        let rocketObjects = realm.objects(RocketObject.self)
        let rockets = Array(rocketObjects).map { createRocketModelElement(from: $0) }
        return rockets
    }

    private func createRocketObject(from rocket: RocketModelElement) -> RocketObject {
        let rocketObject = RocketObject()
        rocketObject.height = createDiameterObject(from: rocket.height)
        rocketObject.diameter = createDiameterObject(from: rocket.diameter)
        rocketObject.mass = createMassObject(from: rocket.mass)
        rocketObject.flickrImages.append(objectsIn: rocket.flickrImages)
        rocketObject.name = rocket.name
        rocketObject.costPerLaunch = rocket.costPerLaunch
        return rocketObject
    }

    private func createDiameterObject(from diameter: RocketModelElement.Diameter) -> DiameterObject {
        let diameterObject = DiameterObject()
        diameterObject.meters = diameter.meters ?? 0
        diameterObject.feet = diameter.feet ?? 0
        return diameterObject
    }

    private func createMassObject(from mass: RocketModelElement.Mass) -> MassObject {
        let massObject = MassObject()
        massObject.kg = mass.kg
        massObject.lb = mass.lb
        return massObject
    }

    private func createRocketModelElement(from rocketObject: RocketObject) -> RocketModelElement {
        let height = createDiameter(from: rocketObject.height)
        let diameter = createDiameter(from: rocketObject.diameter)
        let mass = createMass(from: rocketObject.mass)
        let flickrImages = Array(rocketObject.flickrImages)
        let name = rocketObject.name
        let costPerLaunch = rocketObject.costPerLaunch
        return RocketModelElement(
            height: height,
            diameter: diameter,
            mass: mass,
            flickrImages: flickrImages,
            name: name,
            costPerLaunch: costPerLaunch
        )
    }

    private func createDiameter(from diameterObject: DiameterObject?) -> RocketModelElement.Diameter {
         RocketModelElement.Diameter(meters: diameterObject?.meters, feet: diameterObject?.feet)
    }

    private func createMass(from massObject: MassObject?) -> RocketModelElement.Mass {
        RocketModelElement.Mass(kg: massObject?.kg ?? 0, lb: massObject?.lb ?? 0)
    }
}
