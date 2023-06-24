//
//  Presenter.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import Foundation

protocol RocketViewProtocol: AnyObject {
    func presentSections(data: [Section])
    func presentTableInfo(data: [RocketModelElement])
    func failure(error: Error)
}

protocol RocketPresenterProtocol: AnyObject {
    var view: RocketViewProtocol? { get set }
    func getData()
}

final class RocketPresenter: RocketPresenterProtocol {
    weak var view: RocketViewProtocol?
    private let rocketLoader: RocketLoaderProtocol
    let realmManager: RealmManagerProtocol

    init(rocketLoader: RocketLoaderProtocol, realmManager: RealmManagerProtocol) {
        self.rocketLoader = rocketLoader
        self.realmManager = realmManager
    }

    func getData() {
        self.rocketLoader.rocketDataLoad { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let rockets):
                if rockets.isEmpty {
                    let savedRockets = self.realmManager.getSavedRockets()
                    self.view?.presentTableInfo(data: savedRockets)
                } else {
                    self.view?.presentTableInfo(data: rockets)
                    self.realmManager.saveRockets(rockets)
                }
            case .failure(let error):
                self.view?.failure(error: error)
                let savedRockets = self.realmManager.getSavedRockets()
                self.view?.presentTableInfo(data: savedRockets)
                self.view?.failure(error: error)
            }
        }

            let sections = [
                Section(
                    sectionType: .horizontalPromo,
                    items: [
                        .horizontalPromoInfo(url: Url.promo1Url),
                        .horizontalPromoInfo(url: Url.promo2Url)
                    ]
                ),
                Section(
                    sectionType: .horizontalButton,
                    items: [
                        .horizontalButtonInfo(categorie: "Falcon 1"),
                        .horizontalButtonInfo(categorie: "Falcon 9"),
                        .horizontalButtonInfo(categorie: "Falcon Heavy"),
                        .horizontalButtonInfo(categorie: "Starship")
                    ]
                )
            ]

            self.view?.presentSections(data: sections)
    }
}
