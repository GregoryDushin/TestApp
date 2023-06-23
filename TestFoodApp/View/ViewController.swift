//
//  ViewController.swift
//  TestFoodApp
//
//  Created by Григорий Душин on 23.06.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var tableView: UITableView!
    
    var presenter: RocketPresenterProtocol!
    private var tableViewInfo: [RocketModelElement] = []
    private var snapshot = DataSourceSnapshot()
    private var visibleButtonIndexPaths = Set<IndexPath>()
    private lazy var dataSource = configureCollectionViewDataSource()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.updateButtonColors()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RocketPresenter(rocketLoader: RocketLoader())
        presenter.view = self
        presenter.getData()
        collectionView.collectionViewLayout = createLayout()
        tableView.rowHeight = 550
    }
    
    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
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
                    cell.setup(categorie: categorie, rowIndex: indexPath.row)
                    cell.buttonActionHandler = { [weak self] in
                        self?.scrollTableViewToRow(indexPath.row)
                    }
                    return cell
                }
            }
        
        return dataSource
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
                    layoutSize: .init(widthDimension: .absolute(350), heightDimension: .absolute(180)), subitems: [item]
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
                    layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(90)), subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 3
                section.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
                return section
            }
        }
    }
 
    // MARK: - Creating buttons color change
    
    private func updateButtonColors() {
        guard let topIndexPath = tableView.indexPathsForVisibleRows?.first else {
            return
        }

        collectionView.visibleCells.forEach { cell in
            guard let categoriesCell = cell as? CategoriesCell else {
                return
            }

            let buttonColor: UIColor
            if categoriesCell.tag == topIndexPath.row {
                buttonColor = .gray
            } else {
                buttonColor = .lightGray
            }

            categoriesCell.setButtonColor(buttonColor)
        }
    }

    // MARK: - Table view scrolling
    
    private func scrollTableViewToRow(_ row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewProductCell") as? TableViewProductCell else {
            return UITableViewCell()
        }
        
        let rocket = tableViewInfo[indexPath.row]
        cell.setup(
            url: rocket.flickrImages[0],
            name: rocket.name,
            description: "Country: USA",
            price: "LAST PRICE: " + String(rocket.costPerLaunch / 1000000) + " millions $ !",
            height: "Height: " + String(rocket.height.meters!) + " m",
            diameter: "Diameter: " + String(rocket.diameter.meters!) + " m",
            weight: "Weight: " + String(rocket.mass.kg) + " kg"
        )

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }
        
        updateButtonColors()
    }
}

// MARK: - RocketViewProtocol

extension ViewController: RocketViewProtocol {
    
    func failure(error: Error) {
        DispatchQueue.main.async {
            self.showAlert(error.localizedDescription)
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
        
        self.snapshot = snapshot
        dataSource.apply(snapshot)
    }
}
