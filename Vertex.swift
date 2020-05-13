//
//  Vertex.swift
//  Routing
//
//

import Foundation



public struct Vertex<T: Hashable> {
    var data: T
}

extension Vertex: Hashable {
    public var hash: Int { // 1
        return "\(data)".hashValue
    }
    
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {// 2
        return lhs.data == rhs.data
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(data)"
    }
}
