//
//  LandmarkDetailView.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/10/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import SwiftUI
import MapKit

struct LandmarkDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: LandmarkItem.getAllLandmarks()) var landmarkItems:FetchedResults<LandmarkItem>
    
    
    var landmark:LandmarkItem
    
    var body: some View {
        VStack{
            MapView(coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude))
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            
            VStack(alignment:.leading){
                HStack{
                    Text(landmark.name)
                        .font(.title)
                    Button(action: landmark.toggleVisited){
                        if landmark.visited {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Button(action: {openMapsAppWithDirections(landmark: self.landmark)}) {
                    Text(landmark.address)
                        .font(.subheadline)
                }
            }
        }
    }
}

func openMapsAppWithDirections(landmark:LandmarkItem){
    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
    let placeMark = MKPlacemark(coordinate:CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude),addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placeMark)
    mapItem.name = landmark.name
    mapItem.openInMaps(launchOptions: options)
}

struct LandmarkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetailView(landmark: LandmarkItem())
    }
}
