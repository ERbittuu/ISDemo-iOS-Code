//
//  MKMapView.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/27/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
            return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        annotationView.annotation = annotation
        return annotationView
    }
}

extension MKMapView {
    func annotationView(selection: HomeController.Selection, annotation: MKAnnotation?, reuseIdentifier: String) -> MKAnnotationView {
        switch selection {
        case .count:
            let annotationView = self.annotationView(of: CountClusterAnnotationView.self, annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.countLabel.backgroundColor = .red
            return annotationView
        case .imageCount:
            let annotationView = self.annotationView(of: ImageCountClusterAnnotationView.self, annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.countLabel.textColor = .red
            annotationView.image = .pin2
            return annotationView
        case .image:
            let annotationView = self.annotationView(of: MKAnnotationView.self, annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.image = .pin
            return annotationView
        }
    }
}
