//
//  AdjacencyList.swift
//  Routing
//  https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
//

import Foundation

open class AdjacencyList<T: Hashable> {
    public var adjacencyDict : [Vertex<T>: [Edge<T>]] = [:]
    public init() {}
    fileprivate func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight) // original
        adjacencyDict[source]?.append(edge) // original
    }
    fileprivate func addUndirectedEdge(vertices: (Vertex<Element>, Vertex<Element>), weight: Double?) {
        let (source, destination) = vertices
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
}

extension AdjacencyList: Graphable {
    public typealias Element = T
    public func createVertex(data: Element) -> Vertex<Element> {
        let vertex = Vertex(data: data)
        
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        
        return vertex
    }
    public func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertices: (source, destination), weight: weight)
        }
    }
    public func remove(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?){
        let edge = Edge(source: source, destination: destination, weight: weight)
        if(type == .directed){
            guard let edgeIndex = adjacencyDict[source]?.firstIndex(of: edge) else { return }
            adjacencyDict[source]?.remove(at: edgeIndex)
        }
        else{
            let otherEdge = Edge(source: destination, destination: source, weight: weight)
            var edgeIndex = adjacencyDict[source]?.firstIndex(of: edge)
            if(edgeIndex != nil){
                adjacencyDict[source]?.remove(at: edgeIndex!)
            }
            edgeIndex = adjacencyDict[destination]?.firstIndex(of: otherEdge)
            if(edgeIndex != nil){
                adjacencyDict[destination]?.remove(at: edgeIndex!)
            }
            
            
        }
        
    }
    public func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? {
        guard let edges = adjacencyDict[source] else { // 1
            return nil
        }
        
        for edge in edges { // 2
            if edge.destination == destination { // 3
                return edge.weight
            }
        }
        
        return nil // 4
    }
    public func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
        return adjacencyDict[source]
    }
    public var description: CustomStringConvertible {
        var result = ""
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }
    public func contains(source: T,destination: T) -> Bool{
        for (_, edges) in adjacencyDict {
            for (_, edge) in edges.enumerated() {
                if((edge.source.data == source && edge.destination.data == destination) || (edge.source.data == destination && edge.destination.data == source) ){
                    return true
                }
            }
        }
        return false
    }
}




