//
//  Presenter.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import Foundation

protocol RocketViewProtocol: AnyObject {
    func presentSections(data: [Section])
    func presentTableInfo(data:[RocketModelElement])
    func failure(error: Error)
}

protocol RocketPresenterProtocol: AnyObject {
    var view: RocketViewProtocol? { get set }
    func getData()
}

final class RocketPresenter: RocketPresenterProtocol {
    weak var view: RocketViewProtocol?
    private let rocketLoader: RocketLoaderProtocol
    
    init(rocketLoader: RocketLoaderProtocol) {
       self.rocketLoader = rocketLoader
   }
 
}

extension RocketPresenter {

    func getData() {
        
            rocketLoader.rocketDataLoad { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let rockets):
                    self.view?.presentTableInfo(data: rockets)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
       
        let sections = [
            Section(sectionType: .horizontalPromo, title: nil, items: [
                .horizontalPromoInfo(url: "https://st.depositphotos.com/1186248/4216/i/450/depositphotos_42167223-stock-photo-promo.jpg?forcejpeg=true"),
                .horizontalPromoInfo(url: "https://st4.depositphotos.com/37826884/39042/i/600/depositphotos_390426256-stock-photo-mega-sale-concept-horizontal-banner.jpg?forcejpeg=true")]),
            
            Section(sectionType: .horizontalButton, title: nil, items: [.horizontalButtonInfo(categorie: "one"), .horizontalButtonInfo(categorie: "two"), .horizontalButtonInfo(categorie: "three"), .horizontalButtonInfo(categorie: "four")])]
        
        self.view?.presentSections(data: sections)
        
    }
}
