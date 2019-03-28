//
//  HomeController.swift
//  ISDemo
//
//  Created by Utsav Patel on 28/1/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import UIKit
import MapKit

class HomeController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.region = .init(center: region.center, span: .init(latitudeDelta: region.delta, longitudeDelta: region.delta))
        }
    }

    lazy var manager: ClusterManager = { [unowned self] in
        let manager = ClusterManager()
        manager.delegate = self
        manager.maxZoomLevel = 17
        manager.minCountForClustering = 3
        manager.clusterPosition = .nearCenter
        return manager
        }()

    let region = (center: CLLocationCoordinate2D(latitude: 35.689487, longitude: 139.691711), delta: 0.1)

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        manager.add(MeAnnotation(coordinate: region.center))
        fetchDataAndShow()
    }

    func fetchDataAndShow() {
        Network.shared.getPlaces { places in
            let annotations: [Annotation] = places.map { place in
                let annotation = Annotation()
                annotation.title = place.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: place.lat,
                                                               longitude: place.lng)
                return annotation
            }
            self.manager.add(annotations)
            self.manager.reload(mapView: self.mapView)
            
            // SOme issue in showing places
        }
    }

    func removeAnnotations() {
        manager.removeAll()
        manager.reload(mapView: mapView)
    }
}

extension HomeController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            let index = 1
            let identifier = "Cluster\(index)"
            let selection = Selection(rawValue: index)!
            return mapView.annotationView(selection: selection, annotation: annotation, reuseIdentifier: identifier)
        } else if let annotation = annotation as? MeAnnotation {
            let identifier = "Me"
            let annotationView = mapView.annotationView(of: MKAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = .me
            return annotationView
        } else {
            let identifier = "Pin"
            let annotationView = mapView.annotationView(of: MKPinAnnotationView.self, annotation: annotation, reuseIdentifier: identifier)
            annotationView.pinTintColor = .red
            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView) { finished in
            print(finished)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                if zoomRect.isNull {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }

}

extension HomeController: ClusterManagerDelegate {

    func cellSize(for zoomLevel: Double) -> Double? {
        return nil // default
    }

    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return !(annotation is MeAnnotation)
    }

}

extension HomeController {
    enum Selection: Int {
        case count, imageCount, image
    }
}
