//
//  ViewController.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import UIKit

class ViewController: UIViewController {
    
    private let identifier = String(describing: ViewController.self)
    private var viewModel: SearchViewModel
    
    var collectionView: UICollectionView?
    let searchController = UISearchController(searchResultsController: nil)
    
    private let activityIndicatorView: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpCollectionView()
        setUpNavigation()
        setUpSearchController()
        setUpactivityIndicatorView()
        observe(viewModel: viewModel)
    }
    
    private func observe(viewModel: SearchViewModel) {
        viewModel.photos.bind { [weak self] photos in
            print(#function)
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
    
    private func setUpactivityIndicatorView() {
        view.addSubview(activityIndicatorView)
    }

    private func setUpNavigation() {
        title = "Unsplash Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpSearchController() {
        self.searchController.searchBar.delegate = self
        
    }
}

// MARK: - Set up UICollectionView
extension ViewController {
    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            self.layout()
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SearchPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
    }
    
    private func layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(2/5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.photos.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchPhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        if let photos = self.viewModel.photos.value {
            cell.configureItem(with: photos[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        viewModel.search(text: text)
    }
}
