//
//  LandmarkItem.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/10/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import UIKit
import MapKit

public class LandmarkItem: NSManagedObject, Identifiable{
    
    @NSManaged public var name:String
    @NSManaged public var landMarkDescription:String?
    @NSManaged public var address:String
    @NSManaged public var visited:Bool
    @NSManaged public var latitude:Double
    @NSManaged public var longitude:Double
    
    func getCoordinates(){
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.address) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            self.longitude = lon ?? -200.0
            self.latitude = lat ?? -200.0 // -200 isnt a valid coordinate
        }
        
    }
    
    
    
    
}

extension LandmarkItem{
    
    
    fileprivate static func getLandmarkGraph() -> AdjacencyList<String> {
        // calculate all the edge costs here
 
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LandmarkItem")
        
        let distanceGraph = AdjacencyList<String>()
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 0)
        var retval = AdjacencyList<String>()

        do{
            
            let landmarks = try managedContext.fetch(fetchRequest)
            
            
            
            // add all of the distances between points to the graph
            
            for landmark in landmarks{
                let sourceVertex = distanceGraph.createVertex(data: landmark.value(forKey: "name") as! String)
                
                let source = MapKit.MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(landmark.value(forKey: "latitude") as! CLLocationDegrees, landmark.value(forKey: "longitude") as! CLLocationDegrees)))
                
//                print(source.placemark.coordinate)
                
                
                for other in landmarks{
                    
                    // If the edge is already in the graph dont do it again
                    if(distanceGraph.contains(source: landmark.value(forKey: "name") as! String, destination: other.value(forKey: "name") as! String) || other.value(forKey: "name") as! String == landmark.value(forKey: "name") as! String){
                        continue;
                    }
                    
                    var distanceBetween: CLLocationDistance?
                    let destinationVertex = distanceGraph.createVertex(data: other.value(forKey: "name") as! String)
                    
                    let destination = MapKit.MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(other.value(forKey: "latitude") as! CLLocationDegrees, other.value(forKey: "longitude") as! CLLocationDegrees)))
                    
                    
//                    print(destination.placemark.coordinate)
                    
                    
                    let directionsRequest = MKDirections.Request()
                    directionsRequest.source = source
                    directionsRequest.destination = destination
                    
                    
                    let directions = MKDirections(request: directionsRequest)
                    
                    
                    
                    group.enter()
                    directions.calculate{(response, error) in
                        if error != nil{
                            print(error ?? "error")
                        }
//                        distanceBetween = response!.distance / 1609
                        distanceBetween = response?.routes.first?.distance
//                        print("DISTANCE BETWEEN")
//                        print(distanceBetween as Any)
//                        print("\((response?.routes.first!.distance)! / 1609) mi")
                        
                        distanceGraph.add(.undirected, from: sourceVertex, to: destinationVertex, weight: distanceBetween)
                        group.leave()
                    }
                    
                }
            }
            group.notify(queue: .main){
//                print("printing distance graph...")
//                print(distanceGraph.description)
                retval = distanceGraph
//                let sourceVertex = distanceGraph.createVertex(data: "Da flatz")
//                let destinationVertex = distanceGraph.createVertex(data: "Downtown Mall")
//                print(distanceGraph.weight(from: sourceVertex, to: destinationVertex) as Any)
                
            }
            
            
            
        }catch{
            print(error)
        }
        return retval
    }
    
    fileprivate static func getPath(graph: AdjacencyList<String>){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LandmarkItem")
        
        var landmarks: [NSManagedObject] = []
        
        do{
            landmarks = try managedContext.fetch(fetchRequest)
        }catch{
            print(error)
        }
        
//        for (_, edges) in graph.adjacencyDict {
//            for (_, edge) in edges.enumerated() {
//                if((edge.source.data == source && edge.destination.data == destination) || (edge.source.data == destination && edge.destination.data == source) ){
//                    return true
//                }
//            }
//        }
        print(graph.adjacencyDict.keys)
        
        var path: [Vertex<String>] = [] // will have each location in order by ranking
        var currentKey = graph.adjacencyDict.popFirst()!.key

        path.append(currentKey)
        print(graph.description)
                
        
        
        while(path.count < graph.adjacencyDict.keys.count){
            
            let edges = graph.edges(from: currentKey)
            print(edges)
            break
            
            
        }
        
        
        
        
        
    }
    
    static func getAllLandmarks() -> NSFetchRequest<LandmarkItem>{
        // call traveling salesman function
         // give each item a ranking
         // sortdescriptor by the ranking
        
        let distanceGraph = getLandmarkGraph()
        print(distanceGraph)
        getPath(graph: distanceGraph)
        
        // ORIGINAL STUFF
        let request: NSFetchRequest<LandmarkItem> = LandmarkItem.fetchRequest() as! NSFetchRequest<LandmarkItem>
        
        let sortDescriptor = NSSortDescriptor(key:"name",ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    
    // TODO: CHECK IF THIS ACTUALLY TOGGLES
    //******************************************************************************************************
    //******************************************************************************************************
    //******************************************************************************************************
    //******************************************************************************************************
    //******************************************************************************************************
    
    func toggleVisited(){
        self.visited = !self.visited
        do{
            try self.managedObjectContext?.save()
        }catch{
            print(error)
        }
        
        
        
    }
    
    
}
