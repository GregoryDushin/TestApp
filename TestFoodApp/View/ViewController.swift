//
//  ViewController.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 22.06.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>
    
    @IBOutlet private var collectionView: UICollectionView!
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter: RocketPresenterProtocol!
    var tableViewInfo: [RocketModelElement] = []
    
    private lazy var dataSource = configureCollectionViewDataSource()
    private var snapshot = DataSourceSnapshot()
    private var visibleButtonIndexPaths = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = RocketPresenter(rocketLoader: RocketLoader())
        presenter.view = self
        self.presenter = presenter
        presenter.getData()
        collectionView.collectionViewLayout = createLayout()
        configureHeader()
    }
    
    // MARK: - Configure CollectionView DataSource
    
    private func configureCollectionViewDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView) { [weak self] collectionView, indexPath, listItem -> UICollectionViewCell? in
                guard let self = self else { return UICollectionViewCell() }
                
                switch listItem {
                case let .horizontalPromoInfo(url):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "PromotionsCell",
                        for: indexPath
                    ) as? PromotionsCell else { return UICollectionViewCell() }
                    cell.setup(url: url)
                    return cell
                case let .horizontalButtonInfo(categorie):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "CategoriesCell",
                        for: indexPath
                    ) as? CategoriesCell else { return UICollectionViewCell() }
                    cell.setup(categorie: categorie)
                    cell.buttonActionHandler = { [weak self] in
                        self?.scrollTableViewToRow(indexPath.row)
                    }
                    return cell
                }
            }

        return dataSource
    }
    
    private func configureHeader() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderCell",
                    for: indexPath
                  ) as? HeaderCell else { return UICollectionReusableView() }
            
            header.setup(title: self.dataSource.snapshot().sectionIdentifiers[indexPath.section].title ?? "")
            return header
        }
    }
    
    // MARK: - Creating sections using CompositionalLayout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex].sectionType
            switch section {
            case .horizontalPromo:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(300), heightDimension: .absolute(200)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
                
            case .horizontalButton:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(150)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 5
                section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                return section
            }
        }
    }
    
    // MARK: - Table view scrolling
    
    private func scrollTableViewToRow(_ row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableViewProductCell"
        ) as? TableViewProductCell else { return UITableViewCell() }
        
        let rocket = tableViewInfo[indexPath.row]
        cell.setup(url: rocket.flickrImages[0], name: rocket.name, description: rocket.id, price: String(rocket.costPerLaunch))
        
        return cell
    }
}

extension ViewController: RocketViewProtocol {
    
    func failure(error: Error) {
        DispatchQueue.main.async {
            print("Ошибка: \(error)")
        }
    }
    
    func presentTableInfo(data: [RocketModelElement]) {
        DispatchQueue.main.async {
            self.tableViewInfo = data
            self.tableView.reloadData()
        }
    }
    
    func presentSections(data: [Section]) {
        var snapshot = DataSourceSnapshot()
        snapshot = DataSourceSnapshot()
        for section in data {
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot)
    }
}

