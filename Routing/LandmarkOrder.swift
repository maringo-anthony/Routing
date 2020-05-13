//
//  LandmarkOrder.swift
//  Routing
//
//  Created by Anthony MARINGO on 5/11/20.
//  Copyright © 2020 Anthony MARINGO. All rights reserved.
//

import Foundation
import CoreLocation

public class LandmarkOrder{

    @FetchRequest(fetchRequest: LandmarkItem.getAllLandmarks()) var landmarkItems:FetchedResults<LandmarkItem>
        
    
    

    //  Created by xiang xin on 16/3/17.
    func minimumSpanningTreeKruskal<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
        var cost: Int = 0
        var tree = Graph<T>()
        let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })
        
        var unionFind = UnionFind<T>()
        for vertex in graph.vertices {
            unionFind.addSetWith(vertex)
        }
        
        for edge in sortedEdgeListByWeight {
            let v1 = edge.vertex1
            let v2 = edge.vertex2
            if !unionFind.inSameSet(v1, and: v2) {
                cost += edge.weight
                tree.addEdge(edge)
                unionFind.unionSetsContaining(v1, and: v2)
            }
        }
        
        return (cost: cost, tree: tree)
    }

}

