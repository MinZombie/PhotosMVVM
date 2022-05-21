//
//  ViewController.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/07.
//

import UIKit

class PhotoListViewController: UIViewController {
    
    private let identifier = String(describing: PhotoListViewController.self)
    private var viewModel: SearchViewModel!
    
    var collectionView: UICollectionView?
    private(set) var searchController = UISearchController(searchResultsController: nil)
    private(set) var activityIndicatorView: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    convenience init(viewModel: SearchViewModel) {
        self.init()
        self.viewModel = viewModel
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
        
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicatorView.startAnimating()
                    self?.collectionView?.isHidden = true
                } else {
                    self?.activityIndicatorView.stopAnimating()
                    self?.collectionView?.isHidden = false
                }
            }
        }
    }
    
    private func setUpactivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setUpNavigation() {
        title = "Unsplash Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpSearchController() {
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.autocapitalizationType = .none
    }
}

// MARK: - Set up UICollectionView
extension PhotoListViewController {
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
extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchPhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureItem(with: viewModel.photos.value[indexPath.row])
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension PhotoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        viewModel.search(text: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collectionView?.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.collectionView?.isHidden = false
    }
}
