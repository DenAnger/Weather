//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Denis Abramov on 04.12.2023.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private var selectedLocation: CLLocationCoordinate2D? {
        didSet {
            updatePin()
        }
    }
    
    var nameMap = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        
        getUserPin()
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
        )
        map.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }

    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: map)
        let coordinate = map.convert(location, toCoordinateFrom: map)
        selectedLocation = coordinate
    }
    
    private func getUserPin() {
        LocationManager.shared.getUserLocation { [weak self] location in
            
            DispatchQueue.main.async {
                
                guard let strongSelf = self else { return }
                
                strongSelf.selectedLocation = location.coordinate
                
                strongSelf.map.setRegion(
                    MKCoordinateRegion(center: location.coordinate,
                                       span: MKCoordinateSpan(latitudeDelta: 0.3,
                                                              longitudeDelta: 0.3)
                                      ),
                    animated: true)
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
        )
        map.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updatePin() {
        map.removeAnnotations(map.annotations)
        
        if let location = selectedLocation {
            let pin = MKPointAnnotation()
            pin.coordinate = location
            map.addAnnotation(pin)
            
            LocationManager.shared.resolveLocationName(
                with: CLLocation(latitude: location.latitude,
                                 longitude: location.longitude)
            ) { locationName in
                
                let fullName = locationName ?? ""
                let components = fullName.components(separatedBy: ",")
                
                if let cityName = components.first {
                    self.nameMap = cityName
                }
            }
        }
    }
}
