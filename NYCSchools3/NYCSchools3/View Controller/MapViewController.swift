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
    private let scl: [SchoolModel] = []

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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.removeAnnotations(mapView.annotations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomSheet()
        configureLocationManager()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:
                                                                UIImage(systemName: "gearshape.fill"),
                                                            style: UIBarButtonItem.Style.plain,
                                                            target: self, action: #selector(buttonPressed(sender:)))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureMap()
        drawCircle()
        addSchoolAnnotations(schoolList.viewModel?.getSchools() ?? scl)
    }

    @objc func buttonPressed(sender: UIButton) {
        print("hello")
        viewModel?.handleAction(action: .settings)
    }
    func calculateDistance(from: CLLocationCoordinate2D, tol: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let tol = CLLocation(latitude: tol.latitude, longitude: tol.longitude)
        return from.distance(from: tol)
    }
    func addSchoolAnnotations(_ schoolList: [SchoolModel]) {
        let maxDistance = CLLocationDistance(UserDefaults.standard.float(
            forKey: "radius") * 30 )
        for school in schoolList {
            let schoolAnnotation = MKPointAnnotation()
            guard let schoolCoordinate = Utilities.fetchCoordinates(school.location) else {
                return
            }
            let userLocation = locationManager.location?.coordinate ?? mapView.userLocation.coordinate
            let distanceFromUser = calculateDistance(from: userLocation, tol: schoolCoordinate)
            if distanceFromUser.isLessThanOrEqualTo(maxDistance) {
                schoolAnnotation.coordinate = schoolCoordinate
                schoolAnnotation.title = school.schoolName
                schoolAnnotation.subtitle = school.primaryAddress
                mapView.addAnnotation(schoolAnnotation)
            }
        }
    }

    func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    func configureMap() {
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = 0
        let mapWidth: CGFloat = view.frame.width
        let mapHeight: CGFloat = view.frame.size.height-175

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
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let mapOverlay = MKCircle(center: userLocation, radius: CLLocationDistance(UserDefaults.standard.float(
            forKey: "radius")*30 ))
        mapView.setRegion(viewRegion, animated: false)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(mapOverlay)
        mapView.setCameraBoundary(
              MKMapView.CameraBoundary(coordinateRegion: viewRegion),
              animated: false)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 12000)
        mapView.setCameraZoomRange(zoomRange, animated: false)
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
            circleRenderer.strokeColor = .systemBlue
            circleRenderer.alpha = 0.2
            return circleRenderer
        } else {
           return MKOverlayRenderer(overlay: overlay)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view2: MKMarkerAnnotationView
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.pinTintColor = UIColor.red
            pin.canShowCallout = true
            pin.calloutOffset = CGPoint(x: -5, y: 5)
            pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pin

        } else {
            // handle other annotations
            view2 = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: nil)
            view2.canShowCallout = true
            view2.calloutOffset = CGPoint(x: -5, y: 5)
            view2.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view2
        }
    }
}
