import UIKit

extension URL {
    func allLines() async -> Lines {
        Lines(url: self)
    }
}

struct Lines: Sequence {
    
    let url: URL
    
    func makeIterator() -> some IteratorProtocol {
        let lines = (try? String(contentsOf: url).split(separator: "\n")) ?? []
        return LinesIterator(lines: lines)
    }
}


struct LinesIterator: IteratorProtocol {
    
    typealias Element = String
    var lines: [String.SubSequence]
    
    mutating func next() -> Element? {
        if lines.isEmpty {
            return nil
        }
        return String(lines.removeFirst())
    }
}

let endpointURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!

///Much more faster than waiting for a lot of data to be downloaded
Task {
    ///Async Sequence is available in many different other places like notifications
    for try await line in endpointURL.lines {
        print(line)
    }
}

/* Task {
    for line in await endpointURL.allLines() {
        print(line)
    }
} */
