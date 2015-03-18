import Foundation

class Edge {
    var fromVertex: Vertex?
    var toVertex: Vertex?
    var cost: Int
    
    init(fromVertex: Vertex, toVertex: Vertex, cost: Int = 1) {
        self.fromVertex = fromVertex
        self.toVertex = toVertex
        self.cost = cost
        
        toVertex.inEdges.append(self)
        fromVertex.outEdges.append(self)
    }
    
    func destroy() {
        var foundIdx: Int?
        for (index, vertex) in enumerate(toVertex!.outEdges) {
            if vertex === self {
                foundIdx = index
                break
            }
        }
        
        if let index = foundIdx {
            toVertex!.outEdges.removeAtIndex(index)
            foundIdx = nil
        }
        
        toVertex = nil
        
        for (index, vertex) in enumerate(fromVertex!.inEdges) {
            if vertex === self {
                foundIdx = index
                break
            }
        }
        
        if let index = foundIdx {
            fromVertex!.inEdges.removeAtIndex(index)
        }
        
        fromVertex = nil
    }
}

class Vertex: Hashable {
    var label: String!
    var inEdges: Array<Edge>
    var outEdges: Array<Edge>
    var hashValue: Int {
        get {
            return "\(label)".hashValue
        }
    }
    
    init(label: String) {
        self.label = label
        self.inEdges = []
        self.outEdges = []
    }
}

func ==(vertex: Vertex,
    otherVertex: Vertex) -> Bool {
        return vertex.hashValue == otherVertex.hashValue
}

class Graph {
    var vertices: Array<Vertex>
    
    init() {
        self.vertices = []
    }
    
    func addVertex(vertex: Vertex) {
        vertices.append(vertex)
    }
    
    func addEdge(fromVertex: Vertex, toVertex: Vertex, cost: Int = 1) {
        Edge(fromVertex: fromVertex, toVertex: toVertex, cost: cost)
    }
    
    func topologicalSort() -> Array<Vertex> {
        var inEdgeCounts: Dictionary<Vertex, Int> = [:]
        var queue: Array<Vertex> = []
        
        for v in vertices {
            inEdgeCounts[v] = v.inEdges.count
            if v.inEdges.count == 0 {
                queue.append(v)
            }
        }
        
        var sortedVertices = Array<Vertex>()
        
        while !(queue.count == 0) {
            let vertex = queue.removeAtIndex(0)
            sortedVertices.append(vertex)
            
            for e in vertex.outEdges {
                let toVertex = e.toVertex!
                
                inEdgeCounts[toVertex]! -= 1
                if inEdgeCounts[toVertex] == 0 {
                    queue.append(toVertex)
                }
            }
        }
        
        return sortedVertices
    }
}

extension Array {
    // Fisher-Yates shuffle
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(
                UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

let graph = Graph()
let v1 = Vertex(label: "Wash Markov")
let v2 = Vertex(label: "Feed Markov")
let v3 = Vertex(label: "Dry Markov")
let v4 = Vertex(label: "Brush")

graph.addVertex(v1)
graph.addVertex(v2)
graph.addVertex(v3)
graph.addVertex(v4)
graph.addEdge(v1, toVertex: v2)
graph.addEdge(v1, toVertex: v3)
graph.addEdge(v2, toVertex: v4)
graph.addEdge(v3, toVertex: v4)

graph.vertices.shuffle()
graph.topologicalSort()