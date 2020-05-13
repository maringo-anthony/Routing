//
//  MapView.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/10/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPlacemark(coordinate: coordinate)
        uiView.setRegion(region, animated: true)
        uiView.addAnnotation(pin)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: -116.166868, longitude: 34.011286))
    }
}
