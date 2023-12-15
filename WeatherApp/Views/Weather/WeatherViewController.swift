//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Denis Abramov on 05.11.2023.
//

import UIKit

final class WeatherViewController: UIViewController {
    private var viewModel = WeatherViewModel()
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = configureDataSource()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageSize = UIImage.SymbolConfiguration(pointSize: 23)
        let image = UIImage(systemName: "plus")?.withConfiguration(imageSize)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        return button
    }()
    
    private var cityName = ""
    var tabBarHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        viewModel.attachView(view: self)
        collectionView.dataSource = dataSource
        
        setupConstraints()
        
        updateList()
        self.viewModel.getWeatherForSavedLocations()
    }
    
    @objc private func addCity() {
        let cityPrompt = UIAlertController.init(
            title: "Enter town, city, postcode or airport location",
            message: nil,
            preferredStyle: .alert
        )
        cityPrompt.addTextField { cityName in
            cityName.placeholder = "Location Name"
        }
        
        let okAction = UIAlertAction.init(title: "OK",
                                          style: .default) { [self] action in
            
            guard let locationName = cityPrompt.textFields?.first?.text else { return }
            
            self.viewModel.checkIfCityExists(city: locationName) { exists in
                
                if exists {
                    let errorAlert = UIAlertController(title: "Error Alert",
                                                       message: "City already exists",
                                                       preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default,
                                                 handler: nil)
                    
                    errorAlert.addAction(okAction)
                    self.present(errorAlert, animated: true, completion: nil)
                    
                } else {
                    self.viewModel.getWeatherForCity(city: locationName)
                }
            }
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel",
                                              style: .cancel,
                                              handler: nil)
        cityPrompt.addAction(okAction)
        cityPrompt.addAction(cancelAction)
        cityPrompt.preferredAction = okAction
        
        self.present(cityPrompt, animated: true, completion: nil)
    }
    
    func addCityFromMap() {
        
        guard let tabBarController = self.tabBarController as? TabBarController,
              let mapViewController = tabBarController.viewControllers?[1] as? MapViewController else {
            return
        }

        cityName = mapViewController.nameMap

        self.viewModel.checkIfCityExists(city: cityName) { exists in

            if exists {
                let errorAlert = UIAlertController(
                    title: "Error",
                    message: "City already exists. Don't add from map",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK",
                                             style: .default,
                                             handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                self.viewModel.getWeatherForCity(city: self.cityName)
            }
        }
    }
    
    private func updateList() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.weather, toSection: .all)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    
    private func makeCollectionView() -> UICollectionView {        
        var configure = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        configure.trailingSwipeActionsConfigurationProvider = { indexPath in
            return UISwipeActionsConfiguration(
                actions: [UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { [weak self] _, _, completion in
                        
                        guard let self = self else { return }
                        
                        self.viewModel.deleteWeatherForCity(at: indexPath)
                        self.updateList()
                        completion(true)
                    }
                )]
            )
        }
        let layout = UICollectionViewCompositionalLayout.list(using: configure)
        return UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    }

    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, CurrentWeather> {
        let cellRegistration = makeCellRegistration()
        
        return UICollectionViewDiffableDataSource<Section, CurrentWeather>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
    
    private func makeCellRegistration() -> UICollectionView.CellRegistration<WeatherCell, CurrentWeather> {
        UICollectionView.CellRegistration { cell, indexPath, response in
            cell.currentWeather = response
        }
    }
    
    // MARK: - Alert
    private func showWarningAlert(message: String, actions: [UIAlertAction]?) {
        showAlert(title: "Warning", message: message, actions: actions)
    }

    private func showErrorAlert(message: String, actions: [UIAlertAction]?) {
        showAlert(title: "Error", message: message, actions: actions)
    }

    private func showAlert(title: String,
                           message: String,
                           actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        if actions != nil {
            
            for action in actions! {
                alert.addAction(action)
            }
        }

        self.present(alert, animated: true)
    }

    private func okAlertAction() -> UIAlertAction {
       return UIAlertAction(title: "Ok", style: .default, handler: nil)
    }

    private func dismissAnyAlertView() {
        
        if let alert = self.presentedViewController, 
            alert.isKind(of: UIAlertController.self) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Constarints
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            collectionView.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: -tabBarHeight)
        ])
    }
}

extension WeatherViewController: WeatherViewModelProtocol {
    func updateView() {
        updateList()
    }
    
    func failedToFetchWeather(error: String) {
        showErrorAlert(message: error, actions: [okAlertAction()])
    }
}
