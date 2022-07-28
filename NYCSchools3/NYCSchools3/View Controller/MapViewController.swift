//
//  ContentViewController.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    private let mapView = MKMapView()
    private let schoolList: SchoolListViewController
    private let settingsButton = UIButton()
    var viewModel: MapViewModelProtocol?

    init(schoolList: SchoolListViewController) {
        self.schoolList = schoolList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NYC Schools"
        view.backgroundColor = .systemBackground
        mapView.delegate = self
        configureLocationManager()
        configureSettingsButton()
        drawCircle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomSheet()
        configureMap()
    }
    func configureSettingsButton() {
        //
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.tintColor = .systemBlue
        settingsButton.frame = CGRect(x: 375, y: 20, width: 50, height: 100)
        view.addSubview(settingsButton)
    }
    func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    func configureMap(){
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.width
        let mapHeight:CGFloat = view.frame.size.height-175

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
    }
    func drawCircle() {
        let userLocation = locationManager.location?.coordinate ?? mapView.userLocation.coordinate
        //        let span = MKCoordinateSpan(latitudeDelta: 1,longitudeDelta: 1)
        //        let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714), span: span)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        // let region = CLCircularRegion(center: userLocation, radius: 5000, identifier: "geofence")
        mapView.setRegion(viewRegion, animated: true)
        mapView.addOverlay(MKCircle(center: userLocation, radius: 100))
    }

    func bottomSheet() {
        let viewControllerToPresent = schoolList
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        viewControllerToPresent.isModalInPresentation = true
        self.navigationController?.present(viewControllerToPresent, animated: true, completion: nil)
    }
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.blue
            circleRenderer.strokeColor = .blue
            circleRenderer.alpha = 0.2
            return circleRenderer
        }
        else {
           return MKOverlayRenderer(overlay: overlay)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.pinTintColor = UIColor.red
            return pin

        } else {
            // handle other annotations
        }
        return nil
    }
}
